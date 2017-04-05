
// @GENERATOR:play-routes-compiler
// @SOURCE:/Users/jpoulin/dev/httpillage/server-play/conf/routes
// @DATE:Wed Apr 05 10:17:27 EDT 2017

package controllers;

import router.RoutesPrefix;

public class routes {
  
  public static final controllers.ReverseDictionaryController DictionaryController = new controllers.ReverseDictionaryController(RoutesPrefix.byNamePrefix());
  public static final controllers.ReverseAssets Assets = new controllers.ReverseAssets(RoutesPrefix.byNamePrefix());
  public static final controllers.ReverseDispatcherController DispatcherController = new controllers.ReverseDispatcherController(RoutesPrefix.byNamePrefix());
  public static final controllers.ReverseJobResponseController JobResponseController = new controllers.ReverseJobResponseController(RoutesPrefix.byNamePrefix());
  public static final controllers.ReverseNodeController NodeController = new controllers.ReverseNodeController(RoutesPrefix.byNamePrefix());
  public static final controllers.ReverseBruteforceProgressController BruteforceProgressController = new controllers.ReverseBruteforceProgressController(RoutesPrefix.byNamePrefix());
  public static final controllers.ReverseJobController JobController = new controllers.ReverseJobController(RoutesPrefix.byNamePrefix());
  public static final controllers.ReverseJobMatchController JobMatchController = new controllers.ReverseJobMatchController(RoutesPrefix.byNamePrefix());
  public static final controllers.ReverseHealthController HealthController = new controllers.ReverseHealthController(RoutesPrefix.byNamePrefix());

  public static class javascript {
    
    public static final controllers.javascript.ReverseDictionaryController DictionaryController = new controllers.javascript.ReverseDictionaryController(RoutesPrefix.byNamePrefix());
    public static final controllers.javascript.ReverseAssets Assets = new controllers.javascript.ReverseAssets(RoutesPrefix.byNamePrefix());
    public static final controllers.javascript.ReverseDispatcherController DispatcherController = new controllers.javascript.ReverseDispatcherController(RoutesPrefix.byNamePrefix());
    public static final controllers.javascript.ReverseJobResponseController JobResponseController = new controllers.javascript.ReverseJobResponseController(RoutesPrefix.byNamePrefix());
    public static final controllers.javascript.ReverseNodeController NodeController = new controllers.javascript.ReverseNodeController(RoutesPrefix.byNamePrefix());
    public static final controllers.javascript.ReverseBruteforceProgressController BruteforceProgressController = new controllers.javascript.ReverseBruteforceProgressController(RoutesPrefix.byNamePrefix());
    public static final controllers.javascript.ReverseJobController JobController = new controllers.javascript.ReverseJobController(RoutesPrefix.byNamePrefix());
    public static final controllers.javascript.ReverseJobMatchController JobMatchController = new controllers.javascript.ReverseJobMatchController(RoutesPrefix.byNamePrefix());
    public static final controllers.javascript.ReverseHealthController HealthController = new controllers.javascript.ReverseHealthController(RoutesPrefix.byNamePrefix());
  }

}
