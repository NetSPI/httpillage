package dao

import javax.inject.Inject

import entity.{Job, Node}
import org.joda.time.DateTime
import play.api.db.slick.{DatabaseConfigProvider, HasDatabaseConfigProvider}
import slick.driver.JdbcProfile
import com.github.tototoshi.slick.PostgresJodaSupport._

import scala.concurrent.Future

/**
  * Created by jpoulin on 3/25/17.
  */
class JobDAO @Inject()(protected val dbConfigProvider: DatabaseConfigProvider) extends HasDatabaseConfigProvider[JdbcProfile] {
  import driver.api._

  val jobs = TableQuery[JobsTable]
  def all(): Future[Seq[Job]] = db.run(jobs.result)

  def getJobById(id: Long) = db.run(jobs.filter(_.id === id).result.headOption)

  def create = db.run(DBIO.seq(jobs.schema.create))

  def insert(job: Job) = db.run(jobs returning jobs.map(n => (n)) += job)

  class JobsTable(tag: Tag) extends Table[Job](tag, "JOBS") {

    def id = column[Long]("ID", O.PrimaryKey, O.AutoInc)

    def description = column[String]("DESCRIPTION")
    def httpMethod = column[String]("HTTPMETHOD")
    def httpUri = column[String]("HTTPURI")
    def httpHost = column[String]("HTTPHOST")
    def httpHeaders = column[String]("HTTPHEADERS")
    def httpData = column[Option[String]]("HTTPDATA", O.Default(None))
    def attackType = column[String]("ATTACKTYPE")
    def attackMode = column[String]("ATTACKMODE")
    def status = column[Option[String]]("STATUS", O.Default(None))
    def owner = column[Long]("OWNER")
    def dictionaryId = column[Option[Long]]("DICTIONARYID", O.Default(None))
    def bruteforceCharset = column[Option[String]]("BRUTEFORCECHARSET", O.Default(None))
    def nextIndex = column[Option[Long]]("NEXTINDEX", O.Default(None))
    def createdAt = column[DateTime]("CREATEDAT")
    def updatedAt = column[DateTime]("UPDATEDAT")

    def * = (
      id,
      description,
      httpMethod,
      httpUri,
      httpHost,
      httpHeaders,
      httpData,
      attackType,
      attackMode,
      status,
      owner,
      dictionaryId,
      bruteforceCharset,
      nextIndex,
      createdAt,
      updatedAt) <> (Job.tupled, Job.unapply _)
  }
}
