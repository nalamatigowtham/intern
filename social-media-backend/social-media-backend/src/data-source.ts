import 'reflect-metadata';
import { DataSource } from 'typeorm';
import * as dotenv from 'dotenv';
import { User } from './entities/User';
import { Post } from './entities/Post';
import { Like } from './entities/Like';
import { Follow } from './entities/Follow';
import { Hashtag } from './entities/Hashtag';
import { Activity } from './entities/Activity';

dotenv.config();

export const AppDataSource = new DataSource({
  type: 'sqlite',
  database: 'database.sqlite',
  synchronize: false,
  logging: process.env.NODE_ENV === 'development',
  entities: [User, Post, Like, Follow, Hashtag, Activity],
  migrations: ['src/migrations/**/*.ts'],
  subscribers: [],
});
