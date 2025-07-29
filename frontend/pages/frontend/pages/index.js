export default function Home() {
  const questions = [
    "What should Jobly’s home screen look like?",
    "What’s the main color theme?",
    "How should users earn tokens?",
    "Do we add an AI voice assistant now or later?",
    "Should the app start as Web or Mobile?"
  ];

  return (
    <div style={{ fontFamily: "Arial", padding: 20 }}>
      <h1>Welcome to Jobly (Community Build)</h1>
      <p>Answer questions and earn LeafFlow tokens!</p>
      <ul>
        {questions.map((q, i) => (
          <li key={i} style={{ marginBottom: 10 }}>{q}</li>
        ))}
      </ul>
    </div>
  );
}
