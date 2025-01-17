package org.hdmd.hearingdemo.repository;

import org.hdmd.hearingdemo.model.User;
import org.hdmd.hearingdemo.model.recording.Recording;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface UserRepository extends JpaRepository<User, Long> {

}