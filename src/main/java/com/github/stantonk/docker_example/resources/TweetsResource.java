package com.github.stantonk.docker_example.resources;

import com.github.stantonk.docker_example.api.Tweet;

import javax.ws.rs.Consumes;
import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import java.util.Collections;
import java.util.List;

import static javax.ws.rs.core.MediaType.APPLICATION_JSON;

/**
 * Created by stantonk on 1/10/17.
 */
@Path("/tweets")
@Produces(APPLICATION_JSON)
@Consumes(APPLICATION_JSON)
public class TweetsResource {

    @GET
    public List<Tweet> get() {
        return Collections.EMPTY_LIST;
    }
}
