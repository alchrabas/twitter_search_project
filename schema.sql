--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: postgis; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS postgis WITH SCHEMA public;


--
-- Name: EXTENSION postgis; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION postgis IS 'PostGIS geometry, geography, and raster spatial types and functions';


SET search_path = public, pg_catalog;

--
-- Name: getgroup(double precision); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION getgroup(double precision) RETURNS integer
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$select cast(floor($1/30) as integer);$_$;


ALTER FUNCTION public.getgroup(double precision) OWNER TO postgres;

--
-- Name: getgroupstring(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION getgroupstring(integer) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$select ltrim(to_char($1*30, '99999999')) || ' - ' || ltrim(to_char(($1+1)*30,'99999999'));$_$;


ALTER FUNCTION public.getgroupstring(integer) OWNER TO postgres;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: authors; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE authors (
    id integer NOT NULL,
    link character varying(255),
    name character varying(255),
    facebook_id bigint
);


ALTER TABLE authors OWNER TO postgres;

--
-- Name: authors_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE authors_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE authors_id_seq OWNER TO postgres;

--
-- Name: authors_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE authors_id_seq OWNED BY authors.id;


--
-- Name: category; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE category (
    id integer NOT NULL,
    category_name character varying(200)
);


ALTER TABLE category OWNER TO postgres;

--
-- Name: category_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE category_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE category_id_seq OWNER TO postgres;

--
-- Name: category_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE category_id_seq OWNED BY category.id;


--
-- Name: cleaned_tags; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE cleaned_tags (
    tag_id integer NOT NULL,
    name character varying
);


ALTER TABLE cleaned_tags OWNER TO postgres;

--
-- Name: comment_topic; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE comment_topic (
    comment_id integer NOT NULL,
    topic_id integer NOT NULL,
    probability double precision
);


ALTER TABLE comment_topic OWNER TO postgres;

--
-- Name: comment_topic_dziedziczone; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE comment_topic_dziedziczone (
    comment_id integer NOT NULL,
    topic_id integer NOT NULL,
    probability double precision
);


ALTER TABLE comment_topic_dziedziczone OWNER TO postgres;

--
-- Name: comments; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE comments (
    id integer NOT NULL,
    content text,
    date timestamp without time zone,
    title character varying(255),
    author_id integer,
    parent_comment integer,
    post_id integer,
    facebook_id character varying(255),
    link_from_tag text,
    link_from_content text,
    likes integer
);


ALTER TABLE comments OWNER TO postgres;

--
-- Name: comments_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE comments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE comments_id_seq OWNER TO postgres;

--
-- Name: comments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE comments_id_seq OWNED BY comments.id;


--
-- Name: divergence; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE divergence (
    topic_id integer,
    probability double precision,
    date timestamp without time zone,
    author_id integer,
    slot integer
);


ALTER TABLE divergence OWNER TO postgres;

--
-- Name: huff_twitter_users_junction; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE huff_twitter_users_junction (
    huff_author_id integer NOT NULL,
    twitter_user_id bigint NOT NULL
);


ALTER TABLE huff_twitter_users_junction OWNER TO postgres;

--
-- Name: post_lifetime; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE post_lifetime (
    post_id integer NOT NULL,
    lifetime bigint,
    reacttime bigint
);


ALTER TABLE post_lifetime OWNER TO postgres;

--
-- Name: post_tags; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE post_tags (
    post_id integer NOT NULL,
    tag_id integer NOT NULL
);


ALTER TABLE post_tags OWNER TO postgres;

--
-- Name: post_topic; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE post_topic (
    post_id integer NOT NULL,
    topic_id integer NOT NULL,
    probability double precision
);


ALTER TABLE post_topic OWNER TO postgres;

--
-- Name: posts; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE posts (
    id integer NOT NULL,
    content text,
    date timestamp without time zone,
    link character varying(255),
    title character varying(255),
    author_id integer NOT NULL,
    site_id integer,
    category_id integer,
    zrobiona boolean DEFAULT false,
    link_from_tag text,
    link_from_content text,
    fb_shares integer,
    twitter_shares integer,
    pinterest_shares integer,
    google_shares integer
);


ALTER TABLE posts OWNER TO postgres;

--
-- Name: posts_graph_timeslots; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE posts_graph_timeslots (
    slot_nr integer NOT NULL,
    node_id integer NOT NULL,
    eccentricity double precision,
    closnesscentrality double precision,
    betweenesscentrality double precision,
    indegree double precision,
    outdegree double precision,
    degree double precision,
    modularity_class double precision,
    componentnumber double precision,
    strongcompnum double precision,
    clustering double precision,
    pagerank double precision,
    id integer
);


ALTER TABLE posts_graph_timeslots OWNER TO postgres;

--
-- Name: posts_graphs2; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE posts_graphs2 (
    id integer DEFAULT 2 NOT NULL,
    post_id character varying,
    node_id integer,
    eccentricity double precision,
    closnesscentrality double precision,
    betweenesscentrality double precision,
    indegree double precision,
    outdegree double precision,
    degree double precision,
    modularity_class double precision,
    componentnumber double precision,
    strongcompnum double precision,
    clustering double precision,
    pagerank double precision
);


ALTER TABLE posts_graphs2 OWNER TO postgres;

--
-- Name: posts_graphs_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE posts_graphs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE posts_graphs_id_seq OWNER TO postgres;

--
-- Name: posts_graphs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE posts_graphs_id_seq OWNED BY posts_graphs2.id;


--
-- Name: posts_graphs; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE posts_graphs (
    id integer DEFAULT nextval('posts_graphs_id_seq'::regclass) NOT NULL,
    post_id character varying,
    node_id integer,
    eccentricity double precision,
    closnesscentrality double precision,
    betweenesscentrality double precision,
    indegree double precision,
    outdegree double precision,
    degree double precision,
    modularity_class double precision,
    componentnumber double precision,
    strongcompnum double precision,
    clustering double precision,
    pagerank double precision
);


ALTER TABLE posts_graphs OWNER TO postgres;

--
-- Name: posts_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE posts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE posts_id_seq OWNER TO postgres;

--
-- Name: posts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE posts_id_seq OWNED BY posts.id;


--
-- Name: posts_stats_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE posts_stats_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE posts_stats_id_seq OWNER TO postgres;

--
-- Name: retweets; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE retweets (
    tweet_id bigint NOT NULL,
    user_id integer NOT NULL
);


ALTER TABLE retweets OWNER TO postgres;

--
-- Name: tags; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE tags (
    id integer NOT NULL,
    name character varying(255)
);


ALTER TABLE tags OWNER TO postgres;

--
-- Name: tags_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE tags_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE tags_id_seq OWNER TO postgres;

--
-- Name: tags_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE tags_id_seq OWNED BY tags.id;


--
-- Name: topics_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE topics_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE topics_id_seq OWNER TO postgres;

--
-- Name: topics; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE topics (
    id bigint DEFAULT nextval('topics_id_seq'::regclass) NOT NULL,
    keywords character varying(2000)
);


ALTER TABLE topics OWNER TO postgres;

--
-- Name: topics_category; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE topics_category (
    id integer NOT NULL,
    name character varying
);


ALTER TABLE topics_category OWNER TO postgres;

--
-- Name: topics_category_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE topics_category_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE topics_category_id_seq OWNER TO postgres;

--
-- Name: topics_category_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE topics_category_id_seq OWNED BY topics_category.id;


--
-- Name: topics_topics_category; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE topics_topics_category (
    topic_id integer NOT NULL,
    topic_category_id integer NOT NULL
);


ALTER TABLE topics_topics_category OWNER TO postgres;

--
-- Name: tweet_hashtags; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE tweet_hashtags (
    tweet_id bigint NOT NULL,
    hashtag character(1) NOT NULL
);


ALTER TABLE tweet_hashtags OWNER TO postgres;

--
-- Name: tweets; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE tweets (
    text character varying,
    author_id bigint,
    date timestamp with time zone,
    id bigint NOT NULL
);


ALTER TABLE tweets OWNER TO postgres;

--
-- Name: twitter_follows; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE twitter_follows (
    followed bigint NOT NULL,
    follower bigint NOT NULL
);


ALTER TABLE twitter_follows OWNER TO postgres;

--
-- Name: twitter_hashtags; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE twitter_hashtags (
    tweet_id bigint NOT NULL,
    hashtag character varying NOT NULL
);


ALTER TABLE twitter_hashtags OWNER TO postgres;

--
-- Name: twitter_users; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE twitter_users (
    id bigint NOT NULL,
    username character(45),
    real_name character(64),
    avatar_url character(512),
    description character(512),
    location character(512),
    followers integer,
    followed integer
);


ALTER TABLE twitter_users OWNER TO postgres;

--
-- Name: user_divergence; Type: MATERIALIZED VIEW; Schema: public; Owner: postgres; Tablespace: 
--

CREATE MATERIALIZED VIEW user_divergence AS
 SELECT comment_topic_dziedziczone.topic_id,
    comment_topic_dziedziczone.probability,
    comments.date,
    comments.author_id
   FROM (comment_topic_dziedziczone
     JOIN comments ON ((comments.id = comment_topic_dziedziczone.comment_id)))
UNION ALL
 SELECT post_topic.topic_id,
    post_topic.probability,
    posts.date,
    posts.author_id
   FROM (post_topic
     JOIN posts ON ((posts.id = post_topic.post_id)))
  WITH NO DATA;


ALTER TABLE user_divergence OWNER TO postgres;

--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY authors ALTER COLUMN id SET DEFAULT nextval('authors_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY category ALTER COLUMN id SET DEFAULT nextval('category_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY comments ALTER COLUMN id SET DEFAULT nextval('comments_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY posts ALTER COLUMN id SET DEFAULT nextval('posts_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY tags ALTER COLUMN id SET DEFAULT nextval('tags_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY topics_category ALTER COLUMN id SET DEFAULT nextval('topics_category_id_seq'::regclass);


--
-- Name: authors_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY authors
    ADD CONSTRAINT authors_pkey PRIMARY KEY (id);


--
-- Name: category_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY category
    ADD CONSTRAINT category_pkey PRIMARY KEY (id);


--
-- Name: comment_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY comments
    ADD CONSTRAINT comment_pkey PRIMARY KEY (id);


--
-- Name: comment_topic_dziedziczone_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY comment_topic_dziedziczone
    ADD CONSTRAINT comment_topic_dziedziczone_pkey PRIMARY KEY (comment_id, topic_id);


--
-- Name: comment_topic_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY comment_topic
    ADD CONSTRAINT comment_topic_pk PRIMARY KEY (comment_id, topic_id);


--
-- Name: facebook_id_unique; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY authors
    ADD CONSTRAINT facebook_id_unique UNIQUE (facebook_id);


--
-- Name: fb_id_unique; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY comments
    ADD CONSTRAINT fb_id_unique UNIQUE (facebook_id);


--
-- Name: huff_twitter_users_junction_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY huff_twitter_users_junction
    ADD CONSTRAINT huff_twitter_users_junction_pkey PRIMARY KEY (huff_author_id, twitter_user_id);


--
-- Name: id; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY twitter_users
    ADD CONSTRAINT id PRIMARY KEY (id);


--
-- Name: index; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY post_lifetime
    ADD CONSTRAINT index PRIMARY KEY (post_id);


--
-- Name: link_unique; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY authors
    ADD CONSTRAINT link_unique UNIQUE (link);


--
-- Name: name_unique; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY tags
    ADD CONSTRAINT name_unique UNIQUE (name);


--
-- Name: pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY twitter_hashtags
    ADD CONSTRAINT pk PRIMARY KEY (tweet_id, hashtag);


--
-- Name: post_graph_slot_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY posts_graph_timeslots
    ADD CONSTRAINT post_graph_slot_pkey PRIMARY KEY (slot_nr, node_id);


--
-- Name: post_node_unique; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY posts_graphs
    ADD CONSTRAINT post_node_unique UNIQUE (post_id, node_id);


--
-- Name: post_node_unique2; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY posts_graphs2
    ADD CONSTRAINT post_node_unique2 UNIQUE (post_id, node_id);


--
-- Name: post_tags_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY post_tags
    ADD CONSTRAINT post_tags_pkey PRIMARY KEY (post_id, tag_id);


--
-- Name: post_topic_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY post_topic
    ADD CONSTRAINT post_topic_pkey PRIMARY KEY (post_id, topic_id);


--
-- Name: posts_graphs_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY posts_graphs
    ADD CONSTRAINT posts_graphs_pk PRIMARY KEY (id);


--
-- Name: posts_graphs_pk2; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY posts_graphs2
    ADD CONSTRAINT posts_graphs_pk2 PRIMARY KEY (id);


--
-- Name: posts_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY posts
    ADD CONSTRAINT posts_pkey PRIMARY KEY (id);


--
-- Name: retweets_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY retweets
    ADD CONSTRAINT retweets_pkey PRIMARY KEY (tweet_id, user_id);


--
-- Name: site_id_unique; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY posts
    ADD CONSTRAINT site_id_unique UNIQUE (site_id);


--
-- Name: tag_id_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY cleaned_tags
    ADD CONSTRAINT tag_id_pk PRIMARY KEY (tag_id);


--
-- Name: tags_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY tags
    ADD CONSTRAINT tags_pkey PRIMARY KEY (id);


--
-- Name: topic_topic_category_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY topics_topics_category
    ADD CONSTRAINT topic_topic_category_pkey PRIMARY KEY (topic_id, topic_category_id);


--
-- Name: topics_category_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY topics_category
    ADD CONSTRAINT topics_category_pkey PRIMARY KEY (id);


--
-- Name: topics_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY topics
    ADD CONSTRAINT topics_pk PRIMARY KEY (id);


--
-- Name: tweet_hashtags_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY tweet_hashtags
    ADD CONSTRAINT tweet_hashtags_pkey PRIMARY KEY (tweet_id, hashtag);


--
-- Name: tweets_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY tweets
    ADD CONSTRAINT tweets_pkey PRIMARY KEY (id);


--
-- Name: twitter_follows_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY twitter_follows
    ADD CONSTRAINT twitter_follows_pkey PRIMARY KEY (followed, follower);


--
-- Name: uniqe; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY posts_graph_timeslots
    ADD CONSTRAINT uniqe UNIQUE (slot_nr, node_id);


--
-- Name: unique; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY category
    ADD CONSTRAINT "unique" UNIQUE (category_name);


--
-- Name: author_index; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX author_index ON comments USING btree (author_id);


--
-- Name: author_user_div_view_index; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX author_user_div_view_index ON user_divergence USING btree (author_id);


--
-- Name: authors_name_index; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX authors_name_index ON authors USING btree (name DESC);


--
-- Name: comment_topic_dziedziczone_probability; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX comment_topic_dziedziczone_probability ON comment_topic_dziedziczone USING btree (probability);


--
-- Name: comment_topic_probability; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX comment_topic_probability ON comment_topic USING btree (probability);


--
-- Name: date_index; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX date_index ON comments USING btree (date);


--
-- Name: div_auth_index; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX div_auth_index ON divergence USING btree (author_id);


--
-- Name: div_date_index; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX div_date_index ON divergence USING btree (date);


--
-- Name: fb_id_index; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX fb_id_index ON authors USING btree (facebook_id);


--
-- Name: fki_topic_dziedziczone_id_fk; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX fki_topic_dziedziczone_id_fk ON comment_topic_dziedziczone USING btree (topic_id);


--
-- Name: fki_topic_id_fk; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX fki_topic_id_fk ON comment_topic USING btree (topic_id);


--
-- Name: name_index; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX name_index ON tags USING btree (name);


--
-- Name: node_id_indeks; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX node_id_indeks ON posts_graphs USING btree (node_id);


--
-- Name: node_id_indeks2; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX node_id_indeks2 ON posts_graphs2 USING btree (node_id);


--
-- Name: parent_comment_index; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX parent_comment_index ON comments USING btree (parent_comment);


--
-- Name: post_author_index; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX post_author_index ON posts USING btree (author_id);


--
-- Name: post_date_index; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX post_date_index ON posts USING btree (date DESC);


--
-- Name: post_id_indeks; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX post_id_indeks ON posts_graphs USING btree (post_id);


--
-- Name: post_id_indeks2; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX post_id_indeks2 ON posts_graphs2 USING btree (post_id);


--
-- Name: post_id_index; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX post_id_index ON comments USING btree (post_id);


--
-- Name: posttopic_post_id_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX posttopic_post_id_idx ON post_topic USING btree (post_id);


--
-- Name: posttopic_probability_id_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX posttopic_probability_id_idx ON post_topic USING btree (probability);


--
-- Name: posttopic_topic_id_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX posttopic_topic_id_idx ON post_topic USING btree (topic_id);


--
-- Name: topic_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX topic_idx ON topics USING btree (id);


--
-- Name: topic_index; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX topic_index ON divergence USING btree (topic_id);


--
-- Name: author_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY comments
    ADD CONSTRAINT author_fkey FOREIGN KEY (author_id) REFERENCES authors(id);


--
-- Name: author_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY posts
    ADD CONSTRAINT author_fkey FOREIGN KEY (author_id) REFERENCES authors(id);


--
-- Name: category_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY posts
    ADD CONSTRAINT category_fkey FOREIGN KEY (category_id) REFERENCES category(id);


--
-- Name: comment_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY comment_topic
    ADD CONSTRAINT comment_id_fk FOREIGN KEY (comment_id) REFERENCES comments(id);


--
-- Name: huff_twitter_users_junction_huff_author_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY huff_twitter_users_junction
    ADD CONSTRAINT huff_twitter_users_junction_huff_author_id_fkey FOREIGN KEY (huff_author_id) REFERENCES authors(id);


--
-- Name: huff_twitter_users_junction_twitter_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY huff_twitter_users_junction
    ADD CONSTRAINT huff_twitter_users_junction_twitter_user_id_fkey FOREIGN KEY (twitter_user_id) REFERENCES twitter_users(id);


--
-- Name: parentcomment_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY comments
    ADD CONSTRAINT parentcomment_fkey FOREIGN KEY (id) REFERENCES comments(id);


--
-- Name: post_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY post_tags
    ADD CONSTRAINT post_fkey FOREIGN KEY (post_id) REFERENCES posts(id);


--
-- Name: post_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY comments
    ADD CONSTRAINT post_fkey FOREIGN KEY (post_id) REFERENCES posts(id);


--
-- Name: post_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY post_topic
    ADD CONSTRAINT post_id_fk FOREIGN KEY (post_id) REFERENCES posts(id);


--
-- Name: tag_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY post_tags
    ADD CONSTRAINT tag_fkey FOREIGN KEY (tag_id) REFERENCES tags(id);


--
-- Name: tag_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY cleaned_tags
    ADD CONSTRAINT tag_id FOREIGN KEY (tag_id) REFERENCES tags(id);


--
-- Name: topic_categ_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY topics_topics_category
    ADD CONSTRAINT topic_categ_fkey FOREIGN KEY (topic_category_id) REFERENCES topics_category(id);


--
-- Name: topic_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY post_topic
    ADD CONSTRAINT topic_id_fk FOREIGN KEY (topic_id) REFERENCES topics(id);


--
-- Name: topic_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY comment_topic
    ADD CONSTRAINT topic_id_fk FOREIGN KEY (topic_id) REFERENCES topics(id);


--
-- Name: topics_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY topics_topics_category
    ADD CONSTRAINT topics_fkey FOREIGN KEY (topic_id) REFERENCES topics(id);


--
-- Name: tweet_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY twitter_hashtags
    ADD CONSTRAINT tweet_id_fk FOREIGN KEY (tweet_id) REFERENCES tweets(id);


--
-- Name: tweets_author_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY tweets
    ADD CONSTRAINT tweets_author_id_fkey FOREIGN KEY (author_id) REFERENCES twitter_users(id);


--
-- Name: twitter_follows_followed_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY twitter_follows
    ADD CONSTRAINT twitter_follows_followed_fkey FOREIGN KEY (followed) REFERENCES twitter_users(id);


--
-- Name: twitter_follows_follower_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY twitter_follows
    ADD CONSTRAINT twitter_follows_follower_fkey FOREIGN KEY (follower) REFERENCES twitter_users(id);


--
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

