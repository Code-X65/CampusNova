import { Link } from 'react-router-dom';

const NotFound = () => {
    return (
        <div className="flex flex-col items-center justify-center py-12">
            <h2 className="text-4xl font-bold text-gray-900">404</h2>
            <p className="text-lg text-gray-600 mt-2">Page not found</p>
            <Link to="/" className="mt-4 text-blue-600 hover:underline">
                Go back to Dashboard
            </Link>
        </div>
    );
};

export default NotFound;
