class GitAT222 < Formula
  desc "Distributed revision control system"
  homepage "https://git-scm.com"
  url "https://www.kernel.org/pub/software/scm/git/git-2.22.1.tar.xz"
  sha256 "4ce1f93ab77847e9a9d565ee7c94ceadb80ea7d477fe68123f2329f8d4937824"

  keg_only :versioned_formula

  patch do
    url "https://raw.githubusercontent.com/z80oolong/git-config-fix/master/git-2.22.1-fix.diff"
    sha256 "8fc572839ce4e12b8547134be714e563a169b087f89122ac81691ac9a8b8e24f"
  end

  option "with-blk-sha1", "Compile with the block-optimized SHA1 implementation"
  option "without-completions", "Disable bash/zsh completions from 'contrib' directory"
  option "with-subversion", "Use Homebrew's version of SVN"
  option "with-persistent-https", "Build git-remote-persistent-https from 'contrib' directory"

  deprecated_option "with-brewed-svn" => "with-subversion"
  deprecated_option "with-pcre" => "with-pcre2"

  depends_on "pcre2" => :optional
  depends_on "gettext" => :optional
  depends_on "go" => :build if build.with? "persistent-https"

  if OS.mac?
    if MacOS.version < :yosemite
      depends_on "openssl"
      depends_on "curl"
    else
      deprecated_option "with-brewed-openssl" => "with-openssl"
      deprecated_option "with-brewed-curl" => "with-curl"

      option "with-openssl", "Build with Homebrew's OpenSSL instead of using CommonCrypto"
      option "with-curl", "Use Homebrew's version of cURL library"

      depends_on "openssl" => :optional
      depends_on "curl" => :optional
    end
  end

  unless OS.mac?
    depends_on "curl"
    depends_on "expat"
    depends_on "openssl"
    depends_on "tcl-tk" => :optional
    depends_on "zlib"
  end

  if build.with? "subversion"
    depends_on "subversion"
    depends_on "perl" => :recommended
  else
    option "with-perl", "Build against Homebrew's Perl rather than system default"
    depends_on "perl" => :optional
  end

  resource "html" do
    url "https://www.kernel.org/pub/software/scm/git/git-htmldocs-2.19.0.tar.xz"
    sha256 "d5f850b9c6e87ad10ff24801c1c5ab9cd769e9e444881e9fdb8e6cc116fd8040"
  end

  resource "man" do
    url "https://www.kernel.org/pub/software/scm/git/git-manpages-2.19.0.tar.xz"
    sha256 "4e51041b9636a1fdd8887091d1cca8b0cc6af3f1761870edd091e074378e7dcb"
  end

  def install
    # If these things are installed, tell Git build system not to use them
    ENV["NO_FINK"] = "1"
    ENV["NO_DARWIN_PORTS"] = "1"
    ENV["V"] = "1" # build verbosely
    ENV["NO_R_TO_GCC_LINKER"] = "1" # pass arguments to LD correctly
    ENV["PYTHON_PATH"] = which("python")
    ENV["PERL_PATH"] = which("perl")

    perl_version = Utils.popen_read("perl --version")[/v(\d+\.\d+)(?:\.\d+)?/, 1]
    # If building with a non-system Perl search everywhere declared in @INC.
    perl_inc = Utils.popen_read("perl -e 'print join\":\",@INC'").sub(":.", "")

    if build.with? "subversion"
      ENV["PERLLIB_EXTRA"] = %W[
        #{Formula["subversion"].opt_lib}/perl5/site_perl
      ].join(":")
    elsif build.with? "perl"
      ENV["PERLLIB_EXTRA"] = perl_inc
    elsif MacOS.version >= :mavericks
      ENV["PERLLIB_EXTRA"] = %W[
        #{MacOS.active_developer_dir}
        /Library/Developer/CommandLineTools
        /Applications/Xcode.app/Contents/Developer
      ].uniq.map do |p|
        "#{p}/Library/Perl/#{perl_version}/darwin-thread-multi-2level"
      end.join(":")
    end

    unless quiet_system ENV["PERL_PATH"], "-e", "use ExtUtils::MakeMaker"
      ENV["NO_PERL_MAKEMAKER"] = "1"
    end

    ENV["BLK_SHA1"] = "1" if build.with? "blk-sha1"
    ENV["NO_GETTEXT"] = "1" if build.without? "gettext"

    if build.with? "pcre2"
      ENV["USE_LIBPCRE2"] = "1"
      ENV["LIBPCREDIR"] = Formula["pcre2"].opt_prefix
    end

    args = %W[
      prefix=#{prefix}
      sysconfdir=#{etc}
      CC=#{ENV.cc}
      CFLAGS=#{ENV.cflags}
      LDFLAGS=#{ENV.ldflags}
    ]
    args << "NO_TCLTK=1" if build.without? "tcl-tk"

    if build.with?("openssl") || MacOS.version < :yosemite
      openssl_prefix = Formula["openssl"].opt_prefix
      args += %W[NO_APPLE_COMMON_CRYPTO=1 OPENSSLDIR=#{openssl_prefix}]
    else
      args += %w[NO_OPENSSL=1 APPLE_COMMON_CRYPTO=1]
    end

    system "make", "install", *args

    git_core = libexec/"git-core"

    # Install the macOS keychain credential helper
    cd "contrib/credential/osxkeychain" do
      system "make", "CC=#{ENV.cc}",
                     "CFLAGS=#{ENV.cflags}",
                     "LDFLAGS=#{ENV.ldflags}"
      git_core.install "git-credential-osxkeychain"
      system "make", "clean"
    end if OS.mac?

    # Generate diff-highlight perl script executable
    cd "contrib/diff-highlight" do
      system "make"
    end

    # Install the netrc credential helper
    cd "contrib/credential/netrc" do
      system "make", "test"
      git_core.install "git-credential-netrc"
    end

    # Install git-subtree
    cd "contrib/subtree" do
      system "make", "CC=#{ENV.cc}",
                     "CFLAGS=#{ENV.cflags}",
                     "LDFLAGS=#{ENV.ldflags}"
      git_core.install "git-subtree"
    end

    if build.with? "persistent-https"
      cd "contrib/persistent-https" do
        system "make"
        git_core.install "git-remote-persistent-http",
                         "git-remote-persistent-https",
                         "git-remote-persistent-https--proxy"
      end
    end

    if build.with? "completions"
      # install the completion script first because it is inside "contrib"
      bash_completion.install "contrib/completion/git-completion.bash"
      bash_completion.install "contrib/completion/git-prompt.sh"

      zsh_completion.install "contrib/completion/git-completion.zsh" => "_git"
      cp "#{bash_completion}/git-completion.bash", zsh_completion
    end

    elisp.install Dir["contrib/emacs/*.el"]
    (share/"git-core").install "contrib"

    # We could build the manpages ourselves, but the build process depends
    # on many other packages, and is somewhat crazy, this way is easier.
    man.install resource("man")
    (share/"doc/git-doc").install resource("html")

    # Make html docs world-readable
    chmod 0644, Dir["#{share}/doc/git-doc/**/*.{html,txt}"]
    chmod 0755, Dir["#{share}/doc/git-doc/{RelNotes,howto,technical}"]

    # To avoid this feature hooking into the system OpenSSL, remove it.
    # If you need it, install git --with-openssl.
    if MacOS.version >= :yosemite && build.without?("openssl")
      rm "#{libexec}/git-core/git-imap-send"
    end

    # This is only created when building against system Perl, but it isn't
    # purged by Homebrew's post-install cleaner because that doesn't check
    # "Library" directories. It is however pointless to keep around as it
    # only contains the perllocal.pod installation file.
    rm_rf prefix/"Library/Perl"

    pod = Dir[lib/"*/*/perllocal.pod"][0]
    unless pod.nil?
      # Remove perllocal.pod, which conflicts with the perl formula.
      # I don't know why this issue doesn't affect Mac.
      rm_r Pathname.new(pod).dirname.dirname
    end

    # Set the macOS keychain credential helper by default
    # (as Apple's CLT's git also does this).
    (buildpath/"gitconfig").write <<~EOS
      [credential]
      \thelper = osxkeychain
    EOS
    etc.install "gitconfig" if OS.mac?
  end

  test do
    system bin/"git", "init"
    %w[haunted house].each { |f| touch testpath/f }

    # Test environment has no git configuration, which prevents commiting
    system bin/"git", "config", "user.email", "you@example.com"
    system bin/"git", "config", "user.name", "Your Name"

    system bin/"git", "add", "haunted", "house"
    system bin/"git", "commit", "-a", "-m", "Initial Commit"
    assert_equal "haunted\nhouse", shell_output("#{bin}/git ls-files").strip
  end
end
