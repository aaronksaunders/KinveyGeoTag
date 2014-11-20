function onPostSave(request, response, modules){
  var push = modules.push, collectionAccess = modules.collectionAccess, logger = modules.logger;
  var userCollection = collectionAccess.collection('user');
  var body = request.body;
  if (body.tags && body._geoloc) {
    logger.info("added map note with tags: " + body.tags +", location: "+ body._geoloc);
    var distanceInMiles = 5.0 /*5 mi radius*/ / 3963.192;
    var query = {"tags": {"$in":body.tags}, "_geoloc":{"$nearSphere": body._geoloc,"$maxDistance":distanceInMiles}};
    userCollection.find(query, function (err, userColl) {
      logger.info("got " + userColl.length + " users with matching tags.");
      if (err) {
        logger.error('Query failed: '+ err);
      } else {
        userColl.forEach(function (user) {
          logger.info('Pushing message to ' + user.username);
          push.send(user, "New notes for tag(s): " + body.tags);
        });
      }
      response.continue();
    });
 } else {
   logger.info("no tags in " + body);
   response.continue();
 }
}