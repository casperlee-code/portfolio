import { defineCollection, z } from 'astro:content';
import { glob } from 'astro/loaders';

const projects = defineCollection({
  loader: glob({ pattern: '**/*.{md,mdx}', base: './src/content/projects' }),
  schema: z.object({
    title: z.string(),
    year: z.union([z.string(), z.number()]),
    category: z.enum([
      'School Project',
      'Internship Project',
      'Other Experience',
      'Sketch & Idea'
    ]),
    cover: z.string(),
    images: z.array(z.string()),
    featured: z.boolean()
  })
});

export const collections = { projects };
