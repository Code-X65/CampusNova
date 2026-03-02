import { Routes, Route, Link } from 'react-router-dom'
import { Button } from '@campusnova/ui'

function App() {
  return (
    <div className="min-h-screen bg-gray-50">
      <nav className="p-4 bg-white border-b flex gap-4">
        <Link to="/" className="font-bold text-xl">School Portal</Link>
        <Link to="/dashboard" className="hover:text-blue-600">Dashboard</Link>
        <Link to="/settings" className="hover:text-blue-600">Settings</Link>
        <Link to="/users" className="hover:text-blue-600">Users</Link>
      </nav>

      <main className="p-8">
        <Routes>
          <Route path="/" element={
            <div className="space-y-4">
              <h1 className="text-3xl font-bold">School Management</h1>
              <p className="text-gray-600">Welcome to your School Portal.</p>
              <Button>View Reports</Button>
            </div>
          } />
          <Route path="/dashboard" element={<div>Detailed Dashboard (Placeholder)</div>} />
          <Route path="/settings" element={<div>School Settings (Placeholder)</div>} />
          <Route path="/users" element={<div>User Management (Placeholder)</div>} />
        </Routes>
      </main>
    </div>
  )
}

export default App
