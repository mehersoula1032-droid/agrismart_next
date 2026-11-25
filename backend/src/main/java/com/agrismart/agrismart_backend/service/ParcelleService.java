package com.agrismart.agrismart_backend.service;

import com.agrismart.agrismart_backend.entity.Parcelle;
import com.agrismart.agrismart_backend.repository.ParcelleRepository;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class ParcelleService {

    private final ParcelleRepository parcelleRepository;

    public ParcelleService(ParcelleRepository parcelleRepository) {
        this.parcelleRepository = parcelleRepository;
    }

    // Afficher toutes les parcelles
    public List<Parcelle> getAllParcelles() {
        return parcelleRepository.findAll();
    }

    // Afficher une parcelle par ID
    public Optional<Parcelle> getParcelleById(Long id) {
        return parcelleRepository.findById(id);
    }

    // Ajouter une parcelle
    public Parcelle addParcelle(Parcelle parcelle) {
        return parcelleRepository.save(parcelle);
    }

    // Modifier une parcelle
    public Parcelle updateParcelle(Long id, Parcelle parcelle) {
        parcelle.setId(id);
        return parcelleRepository.save(parcelle);
    }

    // Supprimer une parcelle
    public void deleteParcelle(Long id) {
        parcelleRepository.deleteById(id);
    }
}