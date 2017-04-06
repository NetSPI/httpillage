package dao

import javax.inject.Inject

import entity.JobResponse
import org.joda.time.DateTime
import play.api.db.slick.{DatabaseConfigProvider, HasDatabaseConfigProvider}
import slick.driver.JdbcProfile
import com.github.tototoshi.slick.PostgresJodaSupport._

import scala.concurrent.Future

/**
  * Created by jpoulin on 3/25/17.
  */
class JobResponseDAO @Inject()(protected val dbConfigProvider: DatabaseConfigProvider) extends HasDatabaseConfigProvider[JdbcProfile] {
  import driver.api._

  val jobResponses = TableQuery[JobResponsesTable]
  def all(): Future[Seq[JobResponse]] = db.run(jobResponses.result)

  def getJobResponseById(id: Long) = db.run(jobResponses.filter(_.id === id).result.headOption)
  def getJobResponsesByJobId(jobId: Long): Future[Seq[JobResponse]] = db.run(jobResponses.filter(_.jobId === jobId).result)

  def create = db.run(DBIO.seq(jobResponses.schema.create))

  def insert(jobResponse: JobResponse) = db.run(jobResponses returning jobResponses.map(n => (n)) += jobResponse)

  class JobResponsesTable(tag: Tag) extends Table[JobResponse](tag, "JOBRESPONSES") {

    def id = column[Long]("ID", O.PrimaryKey, O.AutoInc)

    def jobId = column[Long]("JOBID")
    def nodeID = column[Long]("NODEID")
    def responseCode = column[Int]("RESPONSECODE")
    def response = column[String]("RESPONSE")
    def createdAt = column[DateTime]("CREATEDAT")

    def * = (id, jobId, nodeID, responseCode, response, createdAt) <> (JobResponse.tupled, JobResponse.unapply _)

  }
}
