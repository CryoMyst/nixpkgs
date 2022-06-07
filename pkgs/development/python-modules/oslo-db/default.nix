{ lib
, buildPythonPackage
, fetchPypi
, alembic
, oslo-config
, oslo-context
, oslo-utils
, oslotest
, pbr
, sqlalchemy
, sqlalchemy-migrate
, stestr
, testresources
, testscenarios
}:

buildPythonPackage rec {
  pname = "oslo-db";
  version = "11.3.0";

  src = fetchPypi {
    pname = "oslo.db";
    inherit version;
    sha256 = "sha256-CSlZI05V8p+lCgjPcG6LZi4y2nVNrFhjI95TDM/WJnM=";
  };

  nativeBuildInputs = [ pbr ];

  propagatedBuildInputs = [
    alembic
    oslo-config
    oslo-context
    oslo-utils
    sqlalchemy
    sqlalchemy-migrate
    testresources
    testscenarios
  ];

  checkInputs = [
    oslotest
    stestr
  ];

  checkPhase = ''
    stestr run
  '';

  pythonImportsCheck = [ "oslo_db" ];

  meta = with lib; {
    description = "Oslo Database library";
    homepage = "https://github.com/openstack/oslo.db";
    license = licenses.asl20;
    maintainers = teams.openstack.members;
  };
}
