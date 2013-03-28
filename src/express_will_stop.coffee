debug = require("debug")("middleware:express_will_stop")

module.exports = (options)->

  exitWhenDone = options.exitWhenDone || false
  shouldStop = false
  reqs = 0

  process.on("SIGTERM", ->
    debug("SIGTERM, should stop")
    shouldStop = true
    if reqs == 0 && exitWhenDone
      debug("voluntary exit, no active requests")
      process.exit(0)
  )

  return (req, res, next)->
    if shouldStop
      debug("new request, refusing")
      res.send(503)
    else
      reqs++
      debug("#requests = #{reqs}")
      end = res.end
      res.end = (chunk, encoding)->
        res.end = end
        res.end(chunk, encoding)
        reqs--
        debug("#requests = #{reqs}")
        if req == 0
          debug("active requests == 0, can stop safely")
          if exitWhenDone
            debug("voluntary exit")
            process.exit(0)
      next()
