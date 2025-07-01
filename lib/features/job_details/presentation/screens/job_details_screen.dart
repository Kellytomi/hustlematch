import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class JobDetailsScreen extends StatelessWidget {
  final String jobId;
  
  const JobDetailsScreen({super.key, required this.jobId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/discovery'),
        ),
        title: const Text('Job Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Senior Flutter Developer',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'TechCorp Nigeria',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF00C896),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Row(
                children: [
                  Icon(Icons.star, color: Colors.white),
                  SizedBox(width: 8),
                  Text(
                    '87% Match',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text('Job ID: 1 (placeholder data)'),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // TODO: Implement quick apply
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Applied successfully!')),
                  );
                },
                child: const Text('Quick Apply'),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 