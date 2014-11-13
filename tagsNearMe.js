function getTags(request,response,modules,user) {
  var headers = {"Authorization":request.headers.authorization}; //re-use the current user's ACLs rather than master secret
  var loc = user._geoloc;
  var qs = '{"_geoloc":{"$nearSphere":['+loc+'],"$maxDistance":"10"}}'; //find notes within 10 miles
  var uri = 'https://' + request.headers.host + '/appdata/'+request.appKey+'/mapNotes/?query='+qs; //build the request
  modules.request.get({uri: uri, headers: headers}, function(error, res, body){
	if (error){
	  modules.logger.error(error);
	  response.body = {error: error.message};
      response.complete(res.status);
	} else {
	  //iterate through all the notes and count the tags
	  var elements = JSON.parse(body);
	  var tags = {};
	  elements.forEach(function(doc){
		doc.tags.forEach(function(tagar) {
		  if (tags[tagar]) {
			tags[tagar]++;
		  } else {
			tags[tagar] = 1;
		  }
		});
	  });
	  response.body = tags; //return all the tags with their count, could create a count threshold in the future
	  response.complete(200);
	}
});
}

function onRequest(request, response, modules){
  var collectionAccess = modules.collectionAccess;
  //find the current user in the user collection
  collectionAccess.collection('user').find({"username": request.username}, function (err, userColl) {
     if (err) {
         response.body = {error: error.message};
         response.complete(434);
     } else {
         getTags(request,response,modules,userColl[0]);
     }
  });
}