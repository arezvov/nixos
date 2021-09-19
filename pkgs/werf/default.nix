{ lib, buildGoModule, fetchFromGitHub, nixosTests }:

buildGoModule rec {
  pname = "werf";
  version = "1.1.23+fix36";

  subPackages = [ "cmd/werf" ];

  src = fetchFromGitHub {
    owner = "werf";
    repo = "werf";
    rev = "v${version}";
    sha256 = "11rrzp7mmaihr670fvw4qbpi1y8dwdfq79m4fr32wqh1ra0c3q0d";
  };

  vendorSha256 = "179ncpxqydg14ql203yim8nrvzasnfg13bsk7df2925r3vvqcvm8";

  meta = with lib; {
    description = "Consistent delivery tool. The CLI tool glueing Git, Docker, Helm & Kubernetes with any CI system to implement CI/CD and GitOps.";
    license = licenses.asl20;
    homepage = "https://werf.io/";
    maintainers = with maintainers; [ arezvov ];
  };
}

