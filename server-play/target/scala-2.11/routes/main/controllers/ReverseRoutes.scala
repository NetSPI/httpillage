
// @GENERATOR:play-routes-compiler
// @SOURCE:/Users/jpoulin/dev/httpillage/server-play/conf/routes
// @DATE:Wed Apr 05 10:17:27 EDT 2017

import play.api.mvc.{ QueryStringBindable, PathBindable, Call, JavascriptLiteral }
import play.core.routing.{ HandlerDef, ReverseRouteContext, queryString, dynamicString }


import _root_.controllers.Assets.Asset

// @LINE:6
package controllers {

  // @LINE:40
  class ReverseDictionaryController(_prefix: => String) {
    def _defaultPrefix: String = {
      if (_prefix.endsWith("/")) "" else "/"
    }

  
    // @LINE:43
    def deleteDictionary(dictionaryId:Int): Call = {
      import ReverseRouteContext.empty
      Call("DELETE", _prefix + { _defaultPrefix } + "dictionaries/" + implicitly[PathBindable[Int]].unbind("dictionaryId", dictionaryId))
    }
  
    // @LINE:42
    def create(): Call = {
      import ReverseRouteContext.empty
      Call("POST", _prefix + { _defaultPrefix } + "dictionaries")
    }
  
    // @LINE:41
    def getDictionary(dictionaryId:Int): Call = {
      import ReverseRouteContext.empty
      Call("GET", _prefix + { _defaultPrefix } + "dictionaries/" + implicitly[PathBindable[Int]].unbind("dictionaryId", dictionaryId))
    }
  
    // @LINE:40
    def index(): Call = {
      import ReverseRouteContext.empty
      Call("GET", _prefix + { _defaultPrefix } + "dictionaries")
    }
  
  }

  // @LINE:9
  class ReverseAssets(_prefix: => String) {
    def _defaultPrefix: String = {
      if (_prefix.endsWith("/")) "" else "/"
    }

  
    // @LINE:9
    def versioned(file:Asset): Call = {
      implicit val _rrc = new ReverseRouteContext(Map(("path", "/public")))
      Call("GET", _prefix + { _defaultPrefix } + "assets/" + implicitly[PathBindable[Asset]].unbind("file", file))
    }
  
  }

  // @LINE:13
  class ReverseDispatcherController(_prefix: => String) {
    def _defaultPrefix: String = {
      if (_prefix.endsWith("/")) "" else "/"
    }

  
    // @LINE:13
    def poll(): Call = {
      import ReverseRouteContext.empty
      Call("GET", _prefix + { _defaultPrefix } + "poll")
    }
  
    // @LINE:15
    def pollFromNodeForJob(nodeId:Int, jobId:Int): Call = {
      import ReverseRouteContext.empty
      Call("GET", _prefix + { _defaultPrefix } + "poll/" + implicitly[PathBindable[Int]].unbind("nodeId", nodeId) + "/" + implicitly[PathBindable[Int]].unbind("jobId", jobId))
    }
  
    // @LINE:17
    def checkin(nodeId:Int, jobId:Int, statusCode:Int): Call = {
      import ReverseRouteContext.empty
      Call("POST", _prefix + { _defaultPrefix } + "checkin/" + implicitly[PathBindable[Int]].unbind("nodeId", nodeId) + "/" + implicitly[PathBindable[Int]].unbind("jobId", jobId) + "/" + implicitly[PathBindable[Int]].unbind("statusCode", statusCode))
    }
  
    // @LINE:14
    def pollFromNode(nodeId:Int): Call = {
      import ReverseRouteContext.empty
      Call("GET", _prefix + { _defaultPrefix } + "poll/" + implicitly[PathBindable[Int]].unbind("nodeId", nodeId))
    }
  
  }

  // @LINE:29
  class ReverseJobResponseController(_prefix: => String) {
    def _defaultPrefix: String = {
      if (_prefix.endsWith("/")) "" else "/"
    }

  
    // @LINE:30
    def getResponse(jobId:Int, responseId:Int): Call = {
      import ReverseRouteContext.empty
      Call("GET", _prefix + { _defaultPrefix } + "jobs/" + implicitly[PathBindable[Int]].unbind("jobId", jobId) + "/response/" + implicitly[PathBindable[Int]].unbind("responseId", responseId))
    }
  
    // @LINE:32
    def create(jobId:Int): Call = {
      import ReverseRouteContext.empty
      Call("POST", _prefix + { _defaultPrefix } + "jobs/" + implicitly[PathBindable[Int]].unbind("jobId", jobId) + "/saveResponse")
    }
  
    // @LINE:29
    def getResponses(jobId:Int): Call = {
      import ReverseRouteContext.empty
      Call("GET", _prefix + { _defaultPrefix } + "jobs/" + implicitly[PathBindable[Int]].unbind("jobId", jobId) + "/responses")
    }
  
  }

  // @LINE:37
  class ReverseNodeController(_prefix: => String) {
    def _defaultPrefix: String = {
      if (_prefix.endsWith("/")) "" else "/"
    }

  
    // @LINE:37
    def index(): Call = {
      import ReverseRouteContext.empty
      Call("GET", _prefix + { _defaultPrefix } + "nodes")
    }
  
  }

  // @LINE:26
  class ReverseBruteforceProgressController(_prefix: => String) {
    def _defaultPrefix: String = {
      if (_prefix.endsWith("/")) "" else "/"
    }

  
    // @LINE:26
    def getProgress(jobId:Int): Call = {
      import ReverseRouteContext.empty
      Call("GET", _prefix + { _defaultPrefix } + "jobs/" + implicitly[PathBindable[Int]].unbind("jobId", jobId) + "/progress")
    }
  
  }

  // @LINE:19
  class ReverseJobController(_prefix: => String) {
    def _defaultPrefix: String = {
      if (_prefix.endsWith("/")) "" else "/"
    }

  
    // @LINE:22
    def updateJob(jobId:Int): Call = {
      import ReverseRouteContext.empty
      Call("PUT", _prefix + { _defaultPrefix } + "jobs/" + implicitly[PathBindable[Int]].unbind("jobId", jobId))
    }
  
    // @LINE:21
    def create(): Call = {
      import ReverseRouteContext.empty
      Call("POST", _prefix + { _defaultPrefix } + "jobs")
    }
  
    // @LINE:23
    def deleteJob(jobId:Int): Call = {
      import ReverseRouteContext.empty
      Call("DELETE", _prefix + { _defaultPrefix } + "jobs/" + implicitly[PathBindable[Int]].unbind("jobId", jobId))
    }
  
    // @LINE:20
    def getJob(jobId:Int): Call = {
      import ReverseRouteContext.empty
      Call("GET", _prefix + { _defaultPrefix } + "jobs/" + implicitly[PathBindable[Int]].unbind("jobId", jobId))
    }
  
    // @LINE:19
    def index(): Call = {
      import ReverseRouteContext.empty
      Call("GET", _prefix + { _defaultPrefix } + "jobs")
    }
  
  }

  // @LINE:33
  class ReverseJobMatchController(_prefix: => String) {
    def _defaultPrefix: String = {
      if (_prefix.endsWith("/")) "" else "/"
    }

  
    // @LINE:33
    def create(jobId:Int): Call = {
      import ReverseRouteContext.empty
      Call("POST", _prefix + { _defaultPrefix } + "jobs/" + implicitly[PathBindable[Int]].unbind("jobId", jobId) + "/saveMatch")
    }
  
  }

  // @LINE:6
  class ReverseHealthController(_prefix: => String) {
    def _defaultPrefix: String = {
      if (_prefix.endsWith("/")) "" else "/"
    }

  
    // @LINE:6
    def index(): Call = {
    
      () match {
      
        // @LINE:6
        case ()  =>
          import ReverseRouteContext.empty
          Call("GET", _prefix)
      
      }
    
    }
  
  }


}
