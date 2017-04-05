
// @GENERATOR:play-routes-compiler
// @SOURCE:/Users/jpoulin/dev/httpillage/server-play/conf/routes
// @DATE:Wed Apr 05 10:17:27 EDT 2017

import play.api.routing.JavaScriptReverseRoute
import play.api.mvc.{ QueryStringBindable, PathBindable, Call, JavascriptLiteral }
import play.core.routing.{ HandlerDef, ReverseRouteContext, queryString, dynamicString }


import _root_.controllers.Assets.Asset

// @LINE:6
package controllers.javascript {
  import ReverseRouteContext.empty

  // @LINE:40
  class ReverseDictionaryController(_prefix: => String) {

    def _defaultPrefix: String = {
      if (_prefix.endsWith("/")) "" else "/"
    }

  
    // @LINE:43
    def deleteDictionary: JavaScriptReverseRoute = JavaScriptReverseRoute(
      "controllers.DictionaryController.deleteDictionary",
      """
        function(dictionaryId0) {
          return _wA({method:"DELETE", url:"""" + _prefix + { _defaultPrefix } + """" + "dictionaries/" + (""" + implicitly[PathBindable[Int]].javascriptUnbind + """)("dictionaryId", dictionaryId0)})
        }
      """
    )
  
    // @LINE:42
    def create: JavaScriptReverseRoute = JavaScriptReverseRoute(
      "controllers.DictionaryController.create",
      """
        function() {
          return _wA({method:"POST", url:"""" + _prefix + { _defaultPrefix } + """" + "dictionaries"})
        }
      """
    )
  
    // @LINE:41
    def getDictionary: JavaScriptReverseRoute = JavaScriptReverseRoute(
      "controllers.DictionaryController.getDictionary",
      """
        function(dictionaryId0) {
          return _wA({method:"GET", url:"""" + _prefix + { _defaultPrefix } + """" + "dictionaries/" + (""" + implicitly[PathBindable[Int]].javascriptUnbind + """)("dictionaryId", dictionaryId0)})
        }
      """
    )
  
    // @LINE:40
    def index: JavaScriptReverseRoute = JavaScriptReverseRoute(
      "controllers.DictionaryController.index",
      """
        function() {
          return _wA({method:"GET", url:"""" + _prefix + { _defaultPrefix } + """" + "dictionaries"})
        }
      """
    )
  
  }

  // @LINE:9
  class ReverseAssets(_prefix: => String) {

    def _defaultPrefix: String = {
      if (_prefix.endsWith("/")) "" else "/"
    }

  
    // @LINE:9
    def versioned: JavaScriptReverseRoute = JavaScriptReverseRoute(
      "controllers.Assets.versioned",
      """
        function(file1) {
          return _wA({method:"GET", url:"""" + _prefix + { _defaultPrefix } + """" + "assets/" + (""" + implicitly[PathBindable[Asset]].javascriptUnbind + """)("file", file1)})
        }
      """
    )
  
  }

  // @LINE:13
  class ReverseDispatcherController(_prefix: => String) {

    def _defaultPrefix: String = {
      if (_prefix.endsWith("/")) "" else "/"
    }

  
    // @LINE:13
    def poll: JavaScriptReverseRoute = JavaScriptReverseRoute(
      "controllers.DispatcherController.poll",
      """
        function() {
          return _wA({method:"GET", url:"""" + _prefix + { _defaultPrefix } + """" + "poll"})
        }
      """
    )
  
    // @LINE:15
    def pollFromNodeForJob: JavaScriptReverseRoute = JavaScriptReverseRoute(
      "controllers.DispatcherController.pollFromNodeForJob",
      """
        function(nodeId0,jobId1) {
          return _wA({method:"GET", url:"""" + _prefix + { _defaultPrefix } + """" + "poll/" + (""" + implicitly[PathBindable[Int]].javascriptUnbind + """)("nodeId", nodeId0) + "/" + (""" + implicitly[PathBindable[Int]].javascriptUnbind + """)("jobId", jobId1)})
        }
      """
    )
  
    // @LINE:17
    def checkin: JavaScriptReverseRoute = JavaScriptReverseRoute(
      "controllers.DispatcherController.checkin",
      """
        function(nodeId0,jobId1,statusCode2) {
          return _wA({method:"POST", url:"""" + _prefix + { _defaultPrefix } + """" + "checkin/" + (""" + implicitly[PathBindable[Int]].javascriptUnbind + """)("nodeId", nodeId0) + "/" + (""" + implicitly[PathBindable[Int]].javascriptUnbind + """)("jobId", jobId1) + "/" + (""" + implicitly[PathBindable[Int]].javascriptUnbind + """)("statusCode", statusCode2)})
        }
      """
    )
  
    // @LINE:14
    def pollFromNode: JavaScriptReverseRoute = JavaScriptReverseRoute(
      "controllers.DispatcherController.pollFromNode",
      """
        function(nodeId0) {
          return _wA({method:"GET", url:"""" + _prefix + { _defaultPrefix } + """" + "poll/" + (""" + implicitly[PathBindable[Int]].javascriptUnbind + """)("nodeId", nodeId0)})
        }
      """
    )
  
  }

  // @LINE:29
  class ReverseJobResponseController(_prefix: => String) {

    def _defaultPrefix: String = {
      if (_prefix.endsWith("/")) "" else "/"
    }

  
    // @LINE:30
    def getResponse: JavaScriptReverseRoute = JavaScriptReverseRoute(
      "controllers.JobResponseController.getResponse",
      """
        function(jobId0,responseId1) {
          return _wA({method:"GET", url:"""" + _prefix + { _defaultPrefix } + """" + "jobs/" + (""" + implicitly[PathBindable[Int]].javascriptUnbind + """)("jobId", jobId0) + "/response/" + (""" + implicitly[PathBindable[Int]].javascriptUnbind + """)("responseId", responseId1)})
        }
      """
    )
  
    // @LINE:32
    def create: JavaScriptReverseRoute = JavaScriptReverseRoute(
      "controllers.JobResponseController.create",
      """
        function(jobId0) {
          return _wA({method:"POST", url:"""" + _prefix + { _defaultPrefix } + """" + "jobs/" + (""" + implicitly[PathBindable[Int]].javascriptUnbind + """)("jobId", jobId0) + "/saveResponse"})
        }
      """
    )
  
    // @LINE:29
    def getResponses: JavaScriptReverseRoute = JavaScriptReverseRoute(
      "controllers.JobResponseController.getResponses",
      """
        function(jobId0) {
          return _wA({method:"GET", url:"""" + _prefix + { _defaultPrefix } + """" + "jobs/" + (""" + implicitly[PathBindable[Int]].javascriptUnbind + """)("jobId", jobId0) + "/responses"})
        }
      """
    )
  
  }

  // @LINE:37
  class ReverseNodeController(_prefix: => String) {

    def _defaultPrefix: String = {
      if (_prefix.endsWith("/")) "" else "/"
    }

  
    // @LINE:37
    def index: JavaScriptReverseRoute = JavaScriptReverseRoute(
      "controllers.NodeController.index",
      """
        function() {
          return _wA({method:"GET", url:"""" + _prefix + { _defaultPrefix } + """" + "nodes"})
        }
      """
    )
  
  }

  // @LINE:26
  class ReverseBruteforceProgressController(_prefix: => String) {

    def _defaultPrefix: String = {
      if (_prefix.endsWith("/")) "" else "/"
    }

  
    // @LINE:26
    def getProgress: JavaScriptReverseRoute = JavaScriptReverseRoute(
      "controllers.BruteforceProgressController.getProgress",
      """
        function(jobId0) {
          return _wA({method:"GET", url:"""" + _prefix + { _defaultPrefix } + """" + "jobs/" + (""" + implicitly[PathBindable[Int]].javascriptUnbind + """)("jobId", jobId0) + "/progress"})
        }
      """
    )
  
  }

  // @LINE:19
  class ReverseJobController(_prefix: => String) {

    def _defaultPrefix: String = {
      if (_prefix.endsWith("/")) "" else "/"
    }

  
    // @LINE:22
    def updateJob: JavaScriptReverseRoute = JavaScriptReverseRoute(
      "controllers.JobController.updateJob",
      """
        function(jobId0) {
          return _wA({method:"PUT", url:"""" + _prefix + { _defaultPrefix } + """" + "jobs/" + (""" + implicitly[PathBindable[Int]].javascriptUnbind + """)("jobId", jobId0)})
        }
      """
    )
  
    // @LINE:21
    def create: JavaScriptReverseRoute = JavaScriptReverseRoute(
      "controllers.JobController.create",
      """
        function() {
          return _wA({method:"POST", url:"""" + _prefix + { _defaultPrefix } + """" + "jobs"})
        }
      """
    )
  
    // @LINE:23
    def deleteJob: JavaScriptReverseRoute = JavaScriptReverseRoute(
      "controllers.JobController.deleteJob",
      """
        function(jobId0) {
          return _wA({method:"DELETE", url:"""" + _prefix + { _defaultPrefix } + """" + "jobs/" + (""" + implicitly[PathBindable[Int]].javascriptUnbind + """)("jobId", jobId0)})
        }
      """
    )
  
    // @LINE:20
    def getJob: JavaScriptReverseRoute = JavaScriptReverseRoute(
      "controllers.JobController.getJob",
      """
        function(jobId0) {
          return _wA({method:"GET", url:"""" + _prefix + { _defaultPrefix } + """" + "jobs/" + (""" + implicitly[PathBindable[Int]].javascriptUnbind + """)("jobId", jobId0)})
        }
      """
    )
  
    // @LINE:19
    def index: JavaScriptReverseRoute = JavaScriptReverseRoute(
      "controllers.JobController.index",
      """
        function() {
          return _wA({method:"GET", url:"""" + _prefix + { _defaultPrefix } + """" + "jobs"})
        }
      """
    )
  
  }

  // @LINE:33
  class ReverseJobMatchController(_prefix: => String) {

    def _defaultPrefix: String = {
      if (_prefix.endsWith("/")) "" else "/"
    }

  
    // @LINE:33
    def create: JavaScriptReverseRoute = JavaScriptReverseRoute(
      "controllers.JobMatchController.create",
      """
        function(jobId0) {
          return _wA({method:"POST", url:"""" + _prefix + { _defaultPrefix } + """" + "jobs/" + (""" + implicitly[PathBindable[Int]].javascriptUnbind + """)("jobId", jobId0) + "/saveMatch"})
        }
      """
    )
  
  }

  // @LINE:6
  class ReverseHealthController(_prefix: => String) {

    def _defaultPrefix: String = {
      if (_prefix.endsWith("/")) "" else "/"
    }

  
    // @LINE:6
    def index: JavaScriptReverseRoute = JavaScriptReverseRoute(
      "controllers.HealthController.index",
      """
        function() {
        
          if (true) {
            return _wA({method:"GET", url:"""" + _prefix + """"})
          }
        
        }
      """
    )
  
  }


}
