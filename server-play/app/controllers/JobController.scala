package controllers

import javax.inject._

import entity.Job
import org.joda.time.DateTime
import play.api._
import play.api.libs.json.{JsPath, Json, Writes}
import play.api.mvc._
import play.api.libs.functional.syntax._
import services.JobService

import scala.concurrent.Await
import scala.concurrent.duration._

@Singleton
class JobController @Inject()(jobService: JobService) extends Controller {

  def index = Action {
    Ok(Json.toJson(Await.result(jobService.getJobs, 5000 milliseconds)))
  }

  def getJob(jobId: Long) = Action {
    Ok(Json.toJson(Await.result(jobService.getJobById(jobId), 5000 milliseconds)))

  }

  def create = Action {
    Ok
  }

  def updateJob(jobId: Long) = Action {
    Ok
  }

  def deleteJob(jobId: Long) = Action {
    Ok
  }

  implicit val getAllJobWrites: Writes[Job] = (
    (JsPath \ "id").write[Long] and
      (JsPath \ "description").write[String] and
      (JsPath \ "httpMethod").write[String] and
      (JsPath \ "httpUri").write[String] and
      (JsPath \ "httpHost").write[String] and
      (JsPath \ "httpHeaders").write[String] and
      (JsPath \ "httpData").write[Option[String]] and
      (JsPath \ "attackType").write[String] and
      (JsPath \ "attackMode").write[String] and
      (JsPath \ "status").write[Option[String]] and
      (JsPath \ "owner").write[Long] and
      (JsPath \ "dictionaryId").write[Option[Long]] and
      (JsPath \ "bruteforceCharset").write[Option[String]] and
      (JsPath \ "nextIndex").write[Option[Long]] and
      (JsPath \ "createdAt").write[DateTime] and
      (JsPath \ "updatedAt").write[DateTime]
    ) (unlift(Job.unapply))
}