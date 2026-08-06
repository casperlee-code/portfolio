import { defineCollection, z } from 'astro:content';
import { glob } from 'astro/loaders';

const projects = defineCollection({
  loader: glob({ pattern: '**/*.{md,mdx}', base: './src/content/projects' }),
  schema: ({ image }) => z.object({
    title: z.string(),
    year: z.union([z.string(), z.number()]),
    category: z.enum([
      'School Project',
      'Internship Project',
      'Other Experience',
      'Computational Project',
      'Sketch & Idea'
    ]),
    cover: image(),
    images: z.array(image()),
    featured: z.boolean(),
    pdf: z.string().optional(),
    password: z.string().optional()
  })
});

export const collections = { projects };
