class Ankh < Formula
  desc "Another Kubernetes Helper"
  homepage "https://github.com/appnexus/ankh"
  url "https://github.com/appnexus/ankh/archive/v2.0.1.tar.gz"
  sha256 "f6528f5cf29d9364db531ce67c0ff8b2531bf4e895899dd9d64a5dbb60aea3e0"

  depends_on "go" => :build
  depends_on "kubernetes-helm"

  def install
    (buildpath/"src/github.com/appnexus/ankh").install buildpath.children
    cd "src/github.com/appnexus/ankh/ankh" do
      system "go", "build", "-ldflags", "-X main.AnkhBuildVersion=#{version}"
      bin.install "ankh"
    end
  end

  test do
    (testpath/"ankhconfig.yaml").write <<~EOS
      include:
        - minikube.yaml
      environments:
        env-minikube:
      contexts:
        ctx-minikube:
    EOS
    assert_match /^ctx-minikube/, pipe_output("#{bin}/ankh --ankhconfig ankhconfig.yaml config get-contexts")
    assert_match /^env-minikube/, pipe_output("#{bin}/ankh --ankhconfig ankhconfig.yaml config get-environments")
  end
end
