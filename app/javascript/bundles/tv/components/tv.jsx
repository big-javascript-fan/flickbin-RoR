import PropTypes from 'prop-types';
import React from 'react';

const Tv = ({ name, names, filter, addName, updateName, removeName, filterNames, toggleCompletedName }) => {
  console.log(name, names);
  return <div>
    <h3>
      Hello, {name}!
    </h3>
    <hr/>
    <form onSubmit={(e) => {
      e.preventDefault();
      console.log(name);
      addName(name)
    }}>
      <label htmlFor="name">
        Say hello to:
      </label>
      <input
        id="name"
        type="text"
        value={name}
        onChange={(e) => updateName(e.target.value)}
      />
    </form>
    <hr/>
    <div>currentFilter: {filter} </div>
    <ol>
      <li>
        <button onClick={(e) => {
        e.preventDefault();
          filterNames('all');
        }
        }>All</button>
      </li>
      <li>
        <button onClick={(e) => {
          e.preventDefault();
          filterNames('active');
        }
        }>Active</button>
      </li>
      <li>
        <button onClick={(e) => {
          e.preventDefault();
          filterNames('complete');
        }
        }>Complete</button>
      </li>
    </ol>
    <hr/>
    <ul>
      {names.map((name, index) => <li key={index}>
        <button onClick={(e) => {
          e.preventDefault();
          toggleCompletedName(name.id)
        }}>toggle</button>
        {name.complete ? <del>{name.title}</del> : <span>{name.title}</span> }
        <button onClick={(e) => {
          e.preventDefault();
          removeName(name.id)
        }}>Remove</button>
      </li>)}
    </ul>
  </div>
};

Tv.propTypes = {
  name: PropTypes.string.isRequired,
  names: PropTypes.array.isRequired,
  updateName: PropTypes.func.isRequired,
};

export default Tv;
