package controllers

import javax.inject._

import services.JobResponseService
import entity.JobResponse

import org.joda.time.DateTime
import play.api._
import play.api.libs.functional.syntax._
import play.api.libs.json.{JsPath, Json, Writes}
import play.api.mvc._

import scala.concurrent.Await
import scala.concurrent.duration._

@Singleton
class JobResponseController @Inject()(jobResponseService: JobResponseService) extends Controller {

  def create(jobId: Long) = Action {
    Ok
  }

  def getResponses = Action {
    Ok(Json.toJson(Await.result(jobResponseService.getJobResponses, 5000 milliseconds)))
  }

  def getResponsesByJobId(jobId: Long) = Action {
    Ok(Json.toJson(Await.result(jobResponseService.getJobResponsesByJobId(jobId), 5000 milliseconds)))
  }

  def getResponseById(responseId: Long) = Action {
    Ok(Json.toJson(Await.result(jobResponseService.getJobResponsesById(responseId), 5000 milliseconds)))
  }

  implicit val getAllCheckinWrites: Writes[JobResponse] = (
    (JsPath \ "id").write[Long] and
      (JsPath \ "nodeId").write[Long] and
      (JsPath \ "jobId").write[Long] and
      (JsPath \ "responseCode").write[Int] and
      (JsPath \ "response").write[String] and
      (JsPath \ "createdAt").write[DateTime]
    ) (unlift(JobResponse.unapply))
}
