package org.hdmd.hearingdemo.repository;
import org.hdmd.hearingdemo.model.recording.Recording;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;
import java.util.UUID;

@Repository
public interface RecordingRepository extends JpaRepository<Recording, Long> {

}