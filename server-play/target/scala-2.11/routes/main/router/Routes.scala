
// @GENERATOR:play-routes-compiler
// @SOURCE:/Users/jpoulin/dev/httpillage/server-play/conf/routes
// @DATE:Wed Apr 05 10:17:27 EDT 2017

package router

import play.core.routing._
import play.core.routing.HandlerInvokerFactory._
import play.core.j._

import play.api.mvc._

import _root_.controllers.Assets.Asset

class Routes(
  override val errorHandler: play.api.http.HttpErrorHandler, 
  // @LINE:6
  HealthController_5: controllers.HealthController,
  // @LINE:9
  Assets_6: controllers.Assets,
  // @LINE:13
  DispatcherController_0: controllers.DispatcherController,
  // @LINE:19
  JobController_4: controllers.JobController,
  // @LINE:26
  BruteforceProgressController_7: controllers.BruteforceProgressController,
  // @LINE:29
  JobResponseController_1: controllers.JobResponseController,
  // @LINE:33
  JobMatchController_3: controllers.JobMatchController,
  // @LINE:37
  NodeController_8: controllers.NodeController,
  // @LINE:40
  DictionaryController_2: controllers.DictionaryController,
  val prefix: String
) extends GeneratedRouter {

   @javax.inject.Inject()
   def this(errorHandler: play.api.http.HttpErrorHandler,
    // @LINE:6
    HealthController_5: controllers.HealthController,
    // @LINE:9
    Assets_6: controllers.Assets,
    // @LINE:13
    DispatcherController_0: controllers.DispatcherController,
    // @LINE:19
    JobController_4: controllers.JobController,
    // @LINE:26
    BruteforceProgressController_7: controllers.BruteforceProgressController,
    // @LINE:29
    JobResponseController_1: controllers.JobResponseController,
    // @LINE:33
    JobMatchController_3: controllers.JobMatchController,
    // @LINE:37
    NodeController_8: controllers.NodeController,
    // @LINE:40
    DictionaryController_2: controllers.DictionaryController
  ) = this(errorHandler, HealthController_5, Assets_6, DispatcherController_0, JobController_4, BruteforceProgressController_7, JobResponseController_1, JobMatchController_3, NodeController_8, DictionaryController_2, "/")

  import ReverseRouteContext.empty

  def withPrefix(prefix: String): Routes = {
    router.RoutesPrefix.setPrefix(prefix)
    new Routes(errorHandler, HealthController_5, Assets_6, DispatcherController_0, JobController_4, BruteforceProgressController_7, JobResponseController_1, JobMatchController_3, NodeController_8, DictionaryController_2, prefix)
  }

  private[this] val defaultPrefix: String = {
    if (this.prefix.endsWith("/")) "" else "/"
  }

  def documentation = List(
    ("""GET""", this.prefix, """controllers.HealthController.index"""),
    ("""GET""", this.prefix + (if(this.prefix.endsWith("/")) "" else "/") + """assets/""" + "$" + """file<.+>""", """controllers.Assets.versioned(path:String = "/public", file:Asset)"""),
    ("""GET""", this.prefix + (if(this.prefix.endsWith("/")) "" else "/") + """health""", """controllers.HealthController.index"""),
    ("""GET""", this.prefix + (if(this.prefix.endsWith("/")) "" else "/") + """poll""", """controllers.DispatcherController.poll()"""),
    ("""GET""", this.prefix + (if(this.prefix.endsWith("/")) "" else "/") + """poll/""" + "$" + """nodeId<[^/]+>""", """controllers.DispatcherController.pollFromNode(nodeId:Int)"""),
    ("""GET""", this.prefix + (if(this.prefix.endsWith("/")) "" else "/") + """poll/""" + "$" + """nodeId<[^/]+>/""" + "$" + """jobId<[^/]+>""", """controllers.DispatcherController.pollFromNodeForJob(nodeId:Int, jobId:Int)"""),
    ("""POST""", this.prefix + (if(this.prefix.endsWith("/")) "" else "/") + """checkin/""" + "$" + """nodeId<[^/]+>/""" + "$" + """jobId<[^/]+>/""" + "$" + """statusCode<[^/]+>""", """controllers.DispatcherController.checkin(nodeId:Int, jobId:Int, statusCode:Int)"""),
    ("""GET""", this.prefix + (if(this.prefix.endsWith("/")) "" else "/") + """jobs""", """controllers.JobController.index()"""),
    ("""GET""", this.prefix + (if(this.prefix.endsWith("/")) "" else "/") + """jobs/""" + "$" + """jobId<[^/]+>""", """controllers.JobController.getJob(jobId:Int)"""),
    ("""POST""", this.prefix + (if(this.prefix.endsWith("/")) "" else "/") + """jobs""", """controllers.JobController.create()"""),
    ("""PUT""", this.prefix + (if(this.prefix.endsWith("/")) "" else "/") + """jobs/""" + "$" + """jobId<[^/]+>""", """controllers.JobController.updateJob(jobId:Int)"""),
    ("""DELETE""", this.prefix + (if(this.prefix.endsWith("/")) "" else "/") + """jobs/""" + "$" + """jobId<[^/]+>""", """controllers.JobController.deleteJob(jobId:Int)"""),
    ("""GET""", this.prefix + (if(this.prefix.endsWith("/")) "" else "/") + """jobs/""" + "$" + """jobId<[^/]+>/progress""", """controllers.BruteforceProgressController.getProgress(jobId:Int)"""),
    ("""GET""", this.prefix + (if(this.prefix.endsWith("/")) "" else "/") + """jobs/""" + "$" + """jobId<[^/]+>/responses""", """controllers.JobResponseController.getResponses(jobId:Int)"""),
    ("""GET""", this.prefix + (if(this.prefix.endsWith("/")) "" else "/") + """jobs/""" + "$" + """jobId<[^/]+>/response/""" + "$" + """responseId<[^/]+>""", """controllers.JobResponseController.getResponse(jobId:Int, responseId:Int)"""),
    ("""POST""", this.prefix + (if(this.prefix.endsWith("/")) "" else "/") + """jobs/""" + "$" + """jobId<[^/]+>/saveResponse""", """controllers.JobResponseController.create(jobId:Int)"""),
    ("""POST""", this.prefix + (if(this.prefix.endsWith("/")) "" else "/") + """jobs/""" + "$" + """jobId<[^/]+>/saveMatch""", """controllers.JobMatchController.create(jobId:Int)"""),
    ("""GET""", this.prefix + (if(this.prefix.endsWith("/")) "" else "/") + """nodes""", """controllers.NodeController.index()"""),
    ("""GET""", this.prefix + (if(this.prefix.endsWith("/")) "" else "/") + """dictionaries""", """controllers.DictionaryController.index()"""),
    ("""GET""", this.prefix + (if(this.prefix.endsWith("/")) "" else "/") + """dictionaries/""" + "$" + """dictionaryId<[^/]+>""", """controllers.DictionaryController.getDictionary(dictionaryId:Int)"""),
    ("""POST""", this.prefix + (if(this.prefix.endsWith("/")) "" else "/") + """dictionaries""", """controllers.DictionaryController.create()"""),
    ("""DELETE""", this.prefix + (if(this.prefix.endsWith("/")) "" else "/") + """dictionaries/""" + "$" + """dictionaryId<[^/]+>""", """controllers.DictionaryController.deleteDictionary(dictionaryId:Int)"""),
    Nil
  ).foldLeft(List.empty[(String,String,String)]) { (s,e) => e.asInstanceOf[Any] match {
    case r @ (_,_,_) => s :+ r.asInstanceOf[(String,String,String)]
    case l => s ++ l.asInstanceOf[List[(String,String,String)]]
  }}


  // @LINE:6
  private[this] lazy val controllers_HealthController_index0_route = Route("GET",
    PathPattern(List(StaticPart(this.prefix)))
  )
  private[this] lazy val controllers_HealthController_index0_invoker = createInvoker(
    HealthController_5.index,
    HandlerDef(this.getClass.getClassLoader,
      "router",
      "controllers.HealthController",
      "index",
      Nil,
      "GET",
      """ An example controller showing a sample home page""",
      this.prefix + """"""
    )
  )

  // @LINE:9
  private[this] lazy val controllers_Assets_versioned1_route = Route("GET",
    PathPattern(List(StaticPart(this.prefix), StaticPart(this.defaultPrefix), StaticPart("assets/"), DynamicPart("file", """.+""",false)))
  )
  private[this] lazy val controllers_Assets_versioned1_invoker = createInvoker(
    Assets_6.versioned(fakeValue[String], fakeValue[Asset]),
    HandlerDef(this.getClass.getClassLoader,
      "router",
      "controllers.Assets",
      "versioned",
      Seq(classOf[String], classOf[Asset]),
      "GET",
      """ Map static resources from the /public folder to the /assets URL path""",
      this.prefix + """assets/""" + "$" + """file<.+>"""
    )
  )

  // @LINE:11
  private[this] lazy val controllers_HealthController_index2_route = Route("GET",
    PathPattern(List(StaticPart(this.prefix), StaticPart(this.defaultPrefix), StaticPart("health")))
  )
  private[this] lazy val controllers_HealthController_index2_invoker = createInvoker(
    HealthController_5.index,
    HandlerDef(this.getClass.getClassLoader,
      "router",
      "controllers.HealthController",
      "index",
      Nil,
      "GET",
      """""",
      this.prefix + """health"""
    )
  )

  // @LINE:13
  private[this] lazy val controllers_DispatcherController_poll3_route = Route("GET",
    PathPattern(List(StaticPart(this.prefix), StaticPart(this.defaultPrefix), StaticPart("poll")))
  )
  private[this] lazy val controllers_DispatcherController_poll3_invoker = createInvoker(
    DispatcherController_0.poll(),
    HandlerDef(this.getClass.getClassLoader,
      "router",
      "controllers.DispatcherController",
      "poll",
      Nil,
      "GET",
      """""",
      this.prefix + """poll"""
    )
  )

  // @LINE:14
  private[this] lazy val controllers_DispatcherController_pollFromNode4_route = Route("GET",
    PathPattern(List(StaticPart(this.prefix), StaticPart(this.defaultPrefix), StaticPart("poll/"), DynamicPart("nodeId", """[^/]+""",true)))
  )
  private[this] lazy val controllers_DispatcherController_pollFromNode4_invoker = createInvoker(
    DispatcherController_0.pollFromNode(fakeValue[Int]),
    HandlerDef(this.getClass.getClassLoader,
      "router",
      "controllers.DispatcherController",
      "pollFromNode",
      Seq(classOf[Int]),
      "GET",
      """""",
      this.prefix + """poll/""" + "$" + """nodeId<[^/]+>"""
    )
  )

  // @LINE:15
  private[this] lazy val controllers_DispatcherController_pollFromNodeForJob5_route = Route("GET",
    PathPattern(List(StaticPart(this.prefix), StaticPart(this.defaultPrefix), StaticPart("poll/"), DynamicPart("nodeId", """[^/]+""",true), StaticPart("/"), DynamicPart("jobId", """[^/]+""",true)))
  )
  private[this] lazy val controllers_DispatcherController_pollFromNodeForJob5_invoker = createInvoker(
    DispatcherController_0.pollFromNodeForJob(fakeValue[Int], fakeValue[Int]),
    HandlerDef(this.getClass.getClassLoader,
      "router",
      "controllers.DispatcherController",
      "pollFromNodeForJob",
      Seq(classOf[Int], classOf[Int]),
      "GET",
      """""",
      this.prefix + """poll/""" + "$" + """nodeId<[^/]+>/""" + "$" + """jobId<[^/]+>"""
    )
  )

  // @LINE:17
  private[this] lazy val controllers_DispatcherController_checkin6_route = Route("POST",
    PathPattern(List(StaticPart(this.prefix), StaticPart(this.defaultPrefix), StaticPart("checkin/"), DynamicPart("nodeId", """[^/]+""",true), StaticPart("/"), DynamicPart("jobId", """[^/]+""",true), StaticPart("/"), DynamicPart("statusCode", """[^/]+""",true)))
  )
  private[this] lazy val controllers_DispatcherController_checkin6_invoker = createInvoker(
    DispatcherController_0.checkin(fakeValue[Int], fakeValue[Int], fakeValue[Int]),
    HandlerDef(this.getClass.getClassLoader,
      "router",
      "controllers.DispatcherController",
      "checkin",
      Seq(classOf[Int], classOf[Int], classOf[Int]),
      "POST",
      """""",
      this.prefix + """checkin/""" + "$" + """nodeId<[^/]+>/""" + "$" + """jobId<[^/]+>/""" + "$" + """statusCode<[^/]+>"""
    )
  )

  // @LINE:19
  private[this] lazy val controllers_JobController_index7_route = Route("GET",
    PathPattern(List(StaticPart(this.prefix), StaticPart(this.defaultPrefix), StaticPart("jobs")))
  )
  private[this] lazy val controllers_JobController_index7_invoker = createInvoker(
    JobController_4.index(),
    HandlerDef(this.getClass.getClassLoader,
      "router",
      "controllers.JobController",
      "index",
      Nil,
      "GET",
      """""",
      this.prefix + """jobs"""
    )
  )

  // @LINE:20
  private[this] lazy val controllers_JobController_getJob8_route = Route("GET",
    PathPattern(List(StaticPart(this.prefix), StaticPart(this.defaultPrefix), StaticPart("jobs/"), DynamicPart("jobId", """[^/]+""",true)))
  )
  private[this] lazy val controllers_JobController_getJob8_invoker = createInvoker(
    JobController_4.getJob(fakeValue[Int]),
    HandlerDef(this.getClass.getClassLoader,
      "router",
      "controllers.JobController",
      "getJob",
      Seq(classOf[Int]),
      "GET",
      """""",
      this.prefix + """jobs/""" + "$" + """jobId<[^/]+>"""
    )
  )

  // @LINE:21
  private[this] lazy val controllers_JobController_create9_route = Route("POST",
    PathPattern(List(StaticPart(this.prefix), StaticPart(this.defaultPrefix), StaticPart("jobs")))
  )
  private[this] lazy val controllers_JobController_create9_invoker = createInvoker(
    JobController_4.create(),
    HandlerDef(this.getClass.getClassLoader,
      "router",
      "controllers.JobController",
      "create",
      Nil,
      "POST",
      """""",
      this.prefix + """jobs"""
    )
  )

  // @LINE:22
  private[this] lazy val controllers_JobController_updateJob10_route = Route("PUT",
    PathPattern(List(StaticPart(this.prefix), StaticPart(this.defaultPrefix), StaticPart("jobs/"), DynamicPart("jobId", """[^/]+""",true)))
  )
  private[this] lazy val controllers_JobController_updateJob10_invoker = createInvoker(
    JobController_4.updateJob(fakeValue[Int]),
    HandlerDef(this.getClass.getClassLoader,
      "router",
      "controllers.JobController",
      "updateJob",
      Seq(classOf[Int]),
      "PUT",
      """""",
      this.prefix + """jobs/""" + "$" + """jobId<[^/]+>"""
    )
  )

  // @LINE:23
  private[this] lazy val controllers_JobController_deleteJob11_route = Route("DELETE",
    PathPattern(List(StaticPart(this.prefix), StaticPart(this.defaultPrefix), StaticPart("jobs/"), DynamicPart("jobId", """[^/]+""",true)))
  )
  private[this] lazy val controllers_JobController_deleteJob11_invoker = createInvoker(
    JobController_4.deleteJob(fakeValue[Int]),
    HandlerDef(this.getClass.getClassLoader,
      "router",
      "controllers.JobController",
      "deleteJob",
      Seq(classOf[Int]),
      "DELETE",
      """""",
      this.prefix + """jobs/""" + "$" + """jobId<[^/]+>"""
    )
  )

  // @LINE:26
  private[this] lazy val controllers_BruteforceProgressController_getProgress12_route = Route("GET",
    PathPattern(List(StaticPart(this.prefix), StaticPart(this.defaultPrefix), StaticPart("jobs/"), DynamicPart("jobId", """[^/]+""",true), StaticPart("/progress")))
  )
  private[this] lazy val controllers_BruteforceProgressController_getProgress12_invoker = createInvoker(
    BruteforceProgressController_7.getProgress(fakeValue[Int]),
    HandlerDef(this.getClass.getClassLoader,
      "router",
      "controllers.BruteforceProgressController",
      "getProgress",
      Seq(classOf[Int]),
      "GET",
      """ Get the progress of a bruteforce attack""",
      this.prefix + """jobs/""" + "$" + """jobId<[^/]+>/progress"""
    )
  )

  // @LINE:29
  private[this] lazy val controllers_JobResponseController_getResponses13_route = Route("GET",
    PathPattern(List(StaticPart(this.prefix), StaticPart(this.defaultPrefix), StaticPart("jobs/"), DynamicPart("jobId", """[^/]+""",true), StaticPart("/responses")))
  )
  private[this] lazy val controllers_JobResponseController_getResponses13_invoker = createInvoker(
    JobResponseController_1.getResponses(fakeValue[Int]),
    HandlerDef(this.getClass.getClassLoader,
      "router",
      "controllers.JobResponseController",
      "getResponses",
      Seq(classOf[Int]),
      "GET",
      """ Get job responses""",
      this.prefix + """jobs/""" + "$" + """jobId<[^/]+>/responses"""
    )
  )

  // @LINE:30
  private[this] lazy val controllers_JobResponseController_getResponse14_route = Route("GET",
    PathPattern(List(StaticPart(this.prefix), StaticPart(this.defaultPrefix), StaticPart("jobs/"), DynamicPart("jobId", """[^/]+""",true), StaticPart("/response/"), DynamicPart("responseId", """[^/]+""",true)))
  )
  private[this] lazy val controllers_JobResponseController_getResponse14_invoker = createInvoker(
    JobResponseController_1.getResponse(fakeValue[Int], fakeValue[Int]),
    HandlerDef(this.getClass.getClassLoader,
      "router",
      "controllers.JobResponseController",
      "getResponse",
      Seq(classOf[Int], classOf[Int]),
      "GET",
      """""",
      this.prefix + """jobs/""" + "$" + """jobId<[^/]+>/response/""" + "$" + """responseId<[^/]+>"""
    )
  )

  // @LINE:32
  private[this] lazy val controllers_JobResponseController_create15_route = Route("POST",
    PathPattern(List(StaticPart(this.prefix), StaticPart(this.defaultPrefix), StaticPart("jobs/"), DynamicPart("jobId", """[^/]+""",true), StaticPart("/saveResponse")))
  )
  private[this] lazy val controllers_JobResponseController_create15_invoker = createInvoker(
    JobResponseController_1.create(fakeValue[Int]),
    HandlerDef(this.getClass.getClassLoader,
      "router",
      "controllers.JobResponseController",
      "create",
      Seq(classOf[Int]),
      "POST",
      """""",
      this.prefix + """jobs/""" + "$" + """jobId<[^/]+>/saveResponse"""
    )
  )

  // @LINE:33
  private[this] lazy val controllers_JobMatchController_create16_route = Route("POST",
    PathPattern(List(StaticPart(this.prefix), StaticPart(this.defaultPrefix), StaticPart("jobs/"), DynamicPart("jobId", """[^/]+""",true), StaticPart("/saveMatch")))
  )
  private[this] lazy val controllers_JobMatchController_create16_invoker = createInvoker(
    JobMatchController_3.create(fakeValue[Int]),
    HandlerDef(this.getClass.getClassLoader,
      "router",
      "controllers.JobMatchController",
      "create",
      Seq(classOf[Int]),
      "POST",
      """""",
      this.prefix + """jobs/""" + "$" + """jobId<[^/]+>/saveMatch"""
    )
  )

  // @LINE:37
  private[this] lazy val controllers_NodeController_index17_route = Route("GET",
    PathPattern(List(StaticPart(this.prefix), StaticPart(this.defaultPrefix), StaticPart("nodes")))
  )
  private[this] lazy val controllers_NodeController_index17_invoker = createInvoker(
    NodeController_8.index(),
    HandlerDef(this.getClass.getClassLoader,
      "router",
      "controllers.NodeController",
      "index",
      Nil,
      "GET",
      """ Grab a list of nodes""",
      this.prefix + """nodes"""
    )
  )

  // @LINE:40
  private[this] lazy val controllers_DictionaryController_index18_route = Route("GET",
    PathPattern(List(StaticPart(this.prefix), StaticPart(this.defaultPrefix), StaticPart("dictionaries")))
  )
  private[this] lazy val controllers_DictionaryController_index18_invoker = createInvoker(
    DictionaryController_2.index(),
    HandlerDef(this.getClass.getClassLoader,
      "router",
      "controllers.DictionaryController",
      "index",
      Nil,
      "GET",
      """ Handle upload / use of dictionary files""",
      this.prefix + """dictionaries"""
    )
  )

  // @LINE:41
  private[this] lazy val controllers_DictionaryController_getDictionary19_route = Route("GET",
    PathPattern(List(StaticPart(this.prefix), StaticPart(this.defaultPrefix), StaticPart("dictionaries/"), DynamicPart("dictionaryId", """[^/]+""",true)))
  )
  private[this] lazy val controllers_DictionaryController_getDictionary19_invoker = createInvoker(
    DictionaryController_2.getDictionary(fakeValue[Int]),
    HandlerDef(this.getClass.getClassLoader,
      "router",
      "controllers.DictionaryController",
      "getDictionary",
      Seq(classOf[Int]),
      "GET",
      """""",
      this.prefix + """dictionaries/""" + "$" + """dictionaryId<[^/]+>"""
    )
  )

  // @LINE:42
  private[this] lazy val controllers_DictionaryController_create20_route = Route("POST",
    PathPattern(List(StaticPart(this.prefix), StaticPart(this.defaultPrefix), StaticPart("dictionaries")))
  )
  private[this] lazy val controllers_DictionaryController_create20_invoker = createInvoker(
    DictionaryController_2.create(),
    HandlerDef(this.getClass.getClassLoader,
      "router",
      "controllers.DictionaryController",
      "create",
      Nil,
      "POST",
      """""",
      this.prefix + """dictionaries"""
    )
  )

  // @LINE:43
  private[this] lazy val controllers_DictionaryController_deleteDictionary21_route = Route("DELETE",
    PathPattern(List(StaticPart(this.prefix), StaticPart(this.defaultPrefix), StaticPart("dictionaries/"), DynamicPart("dictionaryId", """[^/]+""",true)))
  )
  private[this] lazy val controllers_DictionaryController_deleteDictionary21_invoker = createInvoker(
    DictionaryController_2.deleteDictionary(fakeValue[Int]),
    HandlerDef(this.getClass.getClassLoader,
      "router",
      "controllers.DictionaryController",
      "deleteDictionary",
      Seq(classOf[Int]),
      "DELETE",
      """""",
      this.prefix + """dictionaries/""" + "$" + """dictionaryId<[^/]+>"""
    )
  )


  def routes: PartialFunction[RequestHeader, Handler] = {
  
    // @LINE:6
    case controllers_HealthController_index0_route(params) =>
      call { 
        controllers_HealthController_index0_invoker.call(HealthController_5.index)
      }
  
    // @LINE:9
    case controllers_Assets_versioned1_route(params) =>
      call(Param[String]("path", Right("/public")), params.fromPath[Asset]("file", None)) { (path, file) =>
        controllers_Assets_versioned1_invoker.call(Assets_6.versioned(path, file))
      }
  
    // @LINE:11
    case controllers_HealthController_index2_route(params) =>
      call { 
        controllers_HealthController_index2_invoker.call(HealthController_5.index)
      }
  
    // @LINE:13
    case controllers_DispatcherController_poll3_route(params) =>
      call { 
        controllers_DispatcherController_poll3_invoker.call(DispatcherController_0.poll())
      }
  
    // @LINE:14
    case controllers_DispatcherController_pollFromNode4_route(params) =>
      call(params.fromPath[Int]("nodeId", None)) { (nodeId) =>
        controllers_DispatcherController_pollFromNode4_invoker.call(DispatcherController_0.pollFromNode(nodeId))
      }
  
    // @LINE:15
    case controllers_DispatcherController_pollFromNodeForJob5_route(params) =>
      call(params.fromPath[Int]("nodeId", None), params.fromPath[Int]("jobId", None)) { (nodeId, jobId) =>
        controllers_DispatcherController_pollFromNodeForJob5_invoker.call(DispatcherController_0.pollFromNodeForJob(nodeId, jobId))
      }
  
    // @LINE:17
    case controllers_DispatcherController_checkin6_route(params) =>
      call(params.fromPath[Int]("nodeId", None), params.fromPath[Int]("jobId", None), params.fromPath[Int]("statusCode", None)) { (nodeId, jobId, statusCode) =>
        controllers_DispatcherController_checkin6_invoker.call(DispatcherController_0.checkin(nodeId, jobId, statusCode))
      }
  
    // @LINE:19
    case controllers_JobController_index7_route(params) =>
      call { 
        controllers_JobController_index7_invoker.call(JobController_4.index())
      }
  
    // @LINE:20
    case controllers_JobController_getJob8_route(params) =>
      call(params.fromPath[Int]("jobId", None)) { (jobId) =>
        controllers_JobController_getJob8_invoker.call(JobController_4.getJob(jobId))
      }
  
    // @LINE:21
    case controllers_JobController_create9_route(params) =>
      call { 
        controllers_JobController_create9_invoker.call(JobController_4.create())
      }
  
    // @LINE:22
    case controllers_JobController_updateJob10_route(params) =>
      call(params.fromPath[Int]("jobId", None)) { (jobId) =>
        controllers_JobController_updateJob10_invoker.call(JobController_4.updateJob(jobId))
      }
  
    // @LINE:23
    case controllers_JobController_deleteJob11_route(params) =>
      call(params.fromPath[Int]("jobId", None)) { (jobId) =>
        controllers_JobController_deleteJob11_invoker.call(JobController_4.deleteJob(jobId))
      }
  
    // @LINE:26
    case controllers_BruteforceProgressController_getProgress12_route(params) =>
      call(params.fromPath[Int]("jobId", None)) { (jobId) =>
        controllers_BruteforceProgressController_getProgress12_invoker.call(BruteforceProgressController_7.getProgress(jobId))
      }
  
    // @LINE:29
    case controllers_JobResponseController_getResponses13_route(params) =>
      call(params.fromPath[Int]("jobId", None)) { (jobId) =>
        controllers_JobResponseController_getResponses13_invoker.call(JobResponseController_1.getResponses(jobId))
      }
  
    // @LINE:30
    case controllers_JobResponseController_getResponse14_route(params) =>
      call(params.fromPath[Int]("jobId", None), params.fromPath[Int]("responseId", None)) { (jobId, responseId) =>
        controllers_JobResponseController_getResponse14_invoker.call(JobResponseController_1.getResponse(jobId, responseId))
      }
  
    // @LINE:32
    case controllers_JobResponseController_create15_route(params) =>
      call(params.fromPath[Int]("jobId", None)) { (jobId) =>
        controllers_JobResponseController_create15_invoker.call(JobResponseController_1.create(jobId))
      }
  
    // @LINE:33
    case controllers_JobMatchController_create16_route(params) =>
      call(params.fromPath[Int]("jobId", None)) { (jobId) =>
        controllers_JobMatchController_create16_invoker.call(JobMatchController_3.create(jobId))
      }
  
    // @LINE:37
    case controllers_NodeController_index17_route(params) =>
      call { 
        controllers_NodeController_index17_invoker.call(NodeController_8.index())
      }
  
    // @LINE:40
    case controllers_DictionaryController_index18_route(params) =>
      call { 
        controllers_DictionaryController_index18_invoker.call(DictionaryController_2.index())
      }
  
    // @LINE:41
    case controllers_DictionaryController_getDictionary19_route(params) =>
      call(params.fromPath[Int]("dictionaryId", None)) { (dictionaryId) =>
        controllers_DictionaryController_getDictionary19_invoker.call(DictionaryController_2.getDictionary(dictionaryId))
      }
  
    // @LINE:42
    case controllers_DictionaryController_create20_route(params) =>
      call { 
        controllers_DictionaryController_create20_invoker.call(DictionaryController_2.create())
      }
  
    // @LINE:43
    case controllers_DictionaryController_deleteDictionary21_route(params) =>
      call(params.fromPath[Int]("dictionaryId", None)) { (dictionaryId) =>
        controllers_DictionaryController_deleteDictionary21_invoker.call(DictionaryController_2.deleteDictionary(dictionaryId))
      }
  }
}
