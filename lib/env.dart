enum EnvironmentType { dev, prod, stg }

abstract class Environment {
  EnvironmentType get environment;
}

class Dev implements Environment {
  @override
  EnvironmentType get environment => EnvironmentType.dev;
}

class Stg implements Environment {
  @override
  EnvironmentType get environment => EnvironmentType.stg;
}

class Prod implements Environment {
  @override
  EnvironmentType get environment => EnvironmentType.prod;
}
