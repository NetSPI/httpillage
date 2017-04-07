package controllers

import javax.inject._

import entity.Job
import org.joda.time.DateTime
import play.api._
import play.api.libs.json._
import play.api.mvc._
import play.api.libs.functional.syntax._
import services.JobService

import scala.concurrent.{Await, Future}
import scala.concurrent.duration._

@Singleton
class JobController @Inject()(jobService: JobService) extends Controller {

  def index = Action {
    Ok(Json.toJson(Await.result(jobService.getJobs, 5000 milliseconds)))
  }

  def getJob(jobId: Long) = Action {
    Ok(Json.toJson(Await.result(jobService.getJobById(jobId), 5000 milliseconds)))

  }

  def createJob = Action.async(parse.json) {
    request =>
      import scala.concurrent.ExecutionContext.Implicits.global

      val json = request.body.validate[CreateJob]
      json.fold(
        invalid => {
          Future(BadRequest(Json.obj("status" -> "KO", "message" -> JsError.toJson(invalid))))
        },
        valid => {

          val job = Job(
            -999,
            json.get.description,
            json.get.httpMethod,
            json.get.httpUri,
            json.get.httpHost,
            json.get.httpHeaders,
            json.get.httpData,
            json.get.attackType,
            json.get.attackMode,
            json.get.status,
            json.get.owner,
            json.get.dictionaryId,
            json.get.bruteforceCharset,
            json.get.nextIndex,
            DateTime.now,
            DateTime.now
          )

          jobService.createJob(job).map(j => Ok(Json.toJson(j)))
        }
      )
  }

  def updateJob(jobId: Long) = Action {
    Ok
  }

  def deleteJob(jobId: Long) = Action {
    jobService.deleteJob(jobId)
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

  implicit val jobWrite: Reads[CreateJob] = (
    (JsPath \ "description").read[String] and
      (JsPath \ "httpMethod").read[String] and
      (JsPath \ "httpUri").read[String] and
      (JsPath \ "httpHost").read[String] and
      (JsPath \ "httpHeaders").read[String] and
      (JsPath \ "httpData").readNullable[String] and
      (JsPath \ "attackType").read[String] and
      (JsPath \ "attackMode").read[String] and
      (JsPath \ "status").readNullable[String] and
      (JsPath \ "owner").read[Long] and
      (JsPath \ "dictionaryId").readNullable[Long] and
      (JsPath \ "bruteforceCharset").readNullable[String] and
      (JsPath \ "nextIndex").readNullable[Long] and
      (JsPath \ "createdAt").read[DateTime] and
      (JsPath \ "updatedAt").read[DateTime]
    ) (CreateJob.apply _)

}

case class CreateJob(
                description: String,
                httpMethod: String,
                httpUri: String,
                httpHost: String,
                httpHeaders: String,
                httpData: Option[String],
                attackType: String,
                attackMode: String,
                status: Option[String],
                owner: Long,
                dictionaryId: Option[Long],          // This should be in a different model
                bruteforceCharset: Option[String],  // This should be in a different model
                nextIndex: Option[Long],             // This should be in a different model
                createdAt: DateTime,
                updatedAt: DateTime
              )
