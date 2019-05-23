import PropTypes from 'prop-types';
import React from 'react';

const Tv = ({ name, names, filter, addName, updateName, removeName, filterNames, toggleCompletedName }) => {
  console.log(name, names);
  return <div>
    {/*<div>*/}
      {/*<h3>*/}
        {/*Hello, {name}!*/}
      {/*</h3>*/}
      {/*<hr/>*/}
      {/*<form onSubmit={(e) => {*/}
        {/*e.preventDefault();*/}
        {/*console.log(name);*/}
        {/*addName(name)*/}
      {/*}}>*/}
        {/*<label htmlFor="name">*/}
          {/*Say hello to:*/}
        {/*</label>*/}
        {/*<input*/}
          {/*id="name"*/}
          {/*type="text"*/}
          {/*value={name}*/}
          {/*onChange={(e) => updateName(e.target.value)}*/}
        {/*/>*/}
      {/*</form>*/}
      {/*<hr/>*/}
      {/*<div>currentFilter: {filter} </div>*/}
      {/*<ol>*/}
        {/*<li>*/}
          {/*<button onClick={(e) => {*/}
            {/*e.preventDefault();*/}
            {/*filterNames('all');*/}
          {/*}*/}
          {/*}>All</button>*/}
        {/*</li>*/}
        {/*<li>*/}
          {/*<button onClick={(e) => {*/}
            {/*e.preventDefault();*/}
            {/*filterNames('active');*/}
          {/*}*/}
          {/*}>Active</button>*/}
        {/*</li>*/}
        {/*<li>*/}
          {/*<button onClick={(e) => {*/}
            {/*e.preventDefault();*/}
            {/*filterNames('complete');*/}
          {/*}*/}
          {/*}>Complete</button>*/}
        {/*</li>*/}
      {/*</ol>*/}
      {/*<hr/>*/}
      {/*<ul>*/}
        {/*{names.map((name, index) => <li key={index}>*/}
          {/*<button onClick={(e) => {*/}
            {/*e.preventDefault();*/}
            {/*toggleCompletedName(name.id)*/}
          {/*}}>toggle</button>*/}
          {/*{name.complete ? <del>{name.title}</del> : <span>{name.title}</span> }*/}
          {/*<button onClick={(e) => {*/}
            {/*e.preventDefault();*/}
            {/*removeName(name.id)*/}
          {/*}}>Remove</button>*/}
        {/*</li>)}*/}
      {/*</ul>*/}
    {/*</div>*/}

    <div className="wrapper-tv scroll dark-theme">

      <section className="section section-tv">
        <header className="section-header">
          <div className="section-header-left">
            <a className="brand brand-white" href="/">flickbin</a>
            <div className="videoInfoControls">
              <div id="voting_button" className="upDownOptions clearfix" channelslug="new_blogger">
                <div className="counter-wrapper" loginrequired="true">
                  <span className="counterOption upVote"><span className="icon icon-arrow_drop_up"/></span>
                  <span className="counterNumber counterValueHolder">0</span>
                </div>
              </div>
            </div>
          </div>
          <div className="section-header-right">
            <div className="button-wrapper btnReverseTheme">
              <a className="btn btn-default" href="/users/sign_up">Sign up</a>
              <a className="btn btn-secondary" href="/users/sign_in">Log in</a>
            </div>
          </div>
        </header>
        <div className="section-body">
          <div className="video-wrapper">
            <div className="embed-container">
              <iframe src="https://www.youtube.com/embed/X0DeIqJm4vM?autoplay=1" frameBorder={0} allowFullScreen
                      allow="autoplay"/>
            </div>
          </div>
        </div>
        <footer className="section-footer">
          <div className="section-footer-left">
            <div className="card-tv card-tv-video">
              <figure className="card-media card-media-secondary">
                <img src="https://fakeimg.pl/250x100/" alt="icon"/>
              </figure>
              <div className="card-body card-body-small">
                <h4 className="card-title">
                  Games TV
                </h4>
                <div className="card-description">
                  Now Playing: GIANT DART Vs. BULLETPROOF GLASS from 45m!
                </div>
              </div>
            </div>
          </div>
          <div className="section-footer-right">
            <div className="subscribe-tv">
              <div className="subscribe-tv-watching"><span>1.478</span> Watching</div>
              <a href className="btn btn-subscribe btn-primary">
                <span className="icon-check"/>
                Subscribe
              </a>
            </div>
          </div>
        </footer>
      </section>


      <section className="section-tv-chanel">
        <aside className="section-sidebar">
          <ul className="list list-tv-chanels">
            <li className="list-item">
              <figure className="chanel-icon">
                <img src="https://fakeimg.pl/250x100/" alt="icon" />
              </figure>
            </li>
            <li className="list-item">

            </li>
          </ul>
        </aside>
        <div className="section-body">
          <ul className="list list-slide-videos">
            <li className="list-item">
              <div className="card-tv card-tv-chanel-video">
                <figure className="card-media">
                  <img src="https://fakeimg.pl/250x100/" alt="image" />
                </figure>
                <div className="card-body">
                  <h4 className="card-title">
                    Games TV
                  </h4>
                  <div className="card-description">
                    Now Playing: GIANT DART Vs. BULLETPROOF GLASS from 45m!
                  </div>
                </div>
              </div>
            </li>
            <li className="list-item">
              <div className="card-tv card-tv-chanel-video">
                <figure className="card-media">
                  <img src="https://fakeimg.pl/250x100/" alt="image" />
                </figure>
                <div className="card-body">
                  <h4 className="card-title">
                    Games TV
                  </h4>
                  <div className="card-description">
                    Now Playing: GIANT DART Vs. BULLETPROOF GLASS from 45m!
                  </div>
                </div>
              </div>
            </li>
            <li className="list-item">
              <div className="card-tv card-tv-chanel-video">
                <figure className="card-media">
                  <img src="https://fakeimg.pl/250x100/" alt="image" />
                </figure>
                <div className="card-body">
                  <h4 className="card-title">
                    Games TV
                  </h4>
                  <div className="card-description">
                    Now Playing: GIANT DART Vs. BULLETPROOF GLASS from 45m!
                  </div>
                </div>
              </div>
            </li>
          </ul>
          <ul className="list list-slide-videos">
            <li className="list-item">
              <div className="card-tv card-tv-chanel-video">
                <figure className="card-media">
                  <img src="https://fakeimg.pl/250x100/" alt="image" />
                </figure>
                <div className="card-body">
                  <h4 className="card-title">
                    Games TV
                  </h4>
                  <div className="card-description">
                    Now Playing: GIANT DART Vs. BULLETPROOF GLASS from 45m!
                  </div>
                </div>
              </div>
            </li>
            <li className="list-item">
              <div className="card-tv card-tv-chanel-video">
                <figure className="card-media">
                  <img src="https://fakeimg.pl/250x100/" alt="image" />
                </figure>
                <div className="card-body">
                  <h4 className="card-title">
                    Games TV
                  </h4>
                  <div className="card-description">
                    Now Playing: GIANT DART Vs. BULLETPROOF GLASS from 45m!
                  </div>
                </div>
              </div>
            </li>
            <li className="list-item">
              <div className="card-tv card-tv-chanel-video">
                <figure className="card-media">
                  <img src="https://fakeimg.pl/250x100/" alt="image" />
                </figure>
                <div className="card-body">
                  <h4 className="card-title">
                    Games TV
                  </h4>
                  <div className="card-description">
                    Now Playing: GIANT DART Vs. BULLETPROOF GLASS from 45m!
                  </div>
                </div>
              </div>
            </li>
          </ul>
        </div>
      </section>
    </div>

  </div>
};

Tv.propTypes = {
  name: PropTypes.string.isRequired,
  names: PropTypes.array.isRequired,
  updateName: PropTypes.func.isRequired,
};

export default Tv;
