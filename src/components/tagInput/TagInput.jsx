
import { useEffect, useState } from "react";
import "./style.css"
export default function TagInput({
  onChange = () => {},
  placeholder = undefined,

}) {
  // eslint-disable-next-line no-undef
  const [input, setInput] = useState("");
  // eslint-disable-next-line no-undef
  const [tags, setTags] = useState([]);
  // eslint-disable-next-line no-undef
  const [isKeyReleased, setIsKeyReleased] = useState(false);

  /**
   *
   * @param {React.KeyboardEvent} e
   */
  const handleInputKeyDown = (e) => {
    const { key } = e;
    console.log(key);
    const trimmedInput = input.trim();

    if (key === " " && trimmedInput.length && !tags.includes(trimmedInput)) {
      e.preventDefault();

      setTags((prevState) => [...prevState, trimmedInput]);
      setInput("");
    }

    if (key === "Backspace" && !input.length && tags.length) {
      e.preventDefault();

      const tagsCopy = [...tags];
      const poppedTag = tagsCopy.pop();

      setTags(tagsCopy);
      setInput(poppedTag);
    }

    setIsKeyReleased(false);
  };

  const handleInputKeyUp = () => {
    setIsKeyReleased(true);
  };

  /**
   * @param {React.ChangeEvent} e
   */
  const handleInputChange = (e) => {
    const { value } = e.target;

    setInput(value.replace(/[-*,.@\s]/, "_"));
  };

  const deleteTag = (index) => {
    setTags((prevState) => prevState.filter((_, i) => i !== index));
  };

  useEffect(() => {
    onChange(tags);
  }, [tags.length]);

  return (
    <div className="container">
      {tags.map((tag, index) => (
        <div className="tag" key={index}>
          {tag}
          <button onClick={() => deleteTag(index)}>x</button>
        </div>
      ))}
      <input 
        value={input}
        placeholder={placeholder}
        onKeyDown={handleInputKeyDown}
        onKeyUp={handleInputKeyUp}
        onChange={handleInputChange}
      >
      </input>
    </div>
  );
}
