import { Routes, Route, Link } from 'react-router-dom'
import { Button } from '@campusnova/ui'

function App() {
  return (
    <div className="min-h-screen bg-gray-50">
      <nav className="p-4 bg-white border-b flex gap-4">
        <Link to="/" className="font-bold text-xl">Admin Portal</Link>
        <Link to="/schools" className="hover:text-blue-600">Schools</Link>
        <Link to="/permissions" className="hover:text-blue-600">Permissions</Link>
        <Link to="/roles" className="hover:text-blue-600">Roles</Link>
      </nav>

      <main className="p-8">
        <Routes>
          <Route path="/" element={
            <div className="space-y-4">
              <h1 className="text-3xl font-bold">System Dashboard</h1>
              <p className="text-gray-600">Welcome to CampusNova System Admin.</p>
              <Button>Take Action</Button>
            </div>
          } />
          <Route path="/schools" element={<div>Schools Management (Placeholder)</div>} />
          <Route path="/permissions" element={<div>Permissions (Placeholder)</div>} />
          <Route path="/roles" element={<div>Roles (Placeholder)</div>} />
        </Routes>
      </main>
    </div>
  )
}

export default App
