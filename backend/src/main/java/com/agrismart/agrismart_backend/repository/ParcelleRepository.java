package com.agrismart.agrismart_backend.repository;

import com.agrismart.agrismart_backend.entity.Parcelle;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface ParcelleRepository extends JpaRepository<Parcelle, Long> {

}