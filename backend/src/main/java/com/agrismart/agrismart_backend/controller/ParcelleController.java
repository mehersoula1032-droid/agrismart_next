package com.agrismart.agrismart_backend.controller;

import com.agrismart.agrismart_backend.entity.Parcelle;
import com.agrismart.agrismart_backend.service.ParcelleService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/parcelles")
@CrossOrigin(origins = "*")
public class ParcelleController {

    private final ParcelleService parcelleService;

    public ParcelleController(ParcelleService parcelleService) {
        this.parcelleService = parcelleService;
    }

    // GET : afficher toutes les parcelles
    @GetMapping
    public List<Parcelle> getAllParcelles() {
        return parcelleService.getAllParcelles();
    }

    // GET : afficher une parcelle par ID
    @GetMapping("/{id}")
    public ResponseEntity<Parcelle> getParcelleById(@PathVariable Long id) {
        return parcelleService.getParcelleById(id)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    // POST : ajouter une parcelle
    @PostMapping
    public Parcelle addParcelle(@RequestBody Parcelle parcelle) {
        return parcelleService.addParcelle(parcelle);
    }

    // PUT : modifier une parcelle
    @PutMapping("/{id}")
    public ResponseEntity<Parcelle> updateParcelle(
            @PathVariable Long id,
            @RequestBody Parcelle parcelle) {

        if (!parcelleService.getParcelleById(id).isPresent()) {
            return ResponseEntity.notFound().build();
        }

        parcelle.setId(id);
        return ResponseEntity.ok(parcelleService.updateParcelle(id, parcelle));
    }

    // DELETE : supprimer une parcelle
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteParcelle(@PathVariable Long id) {

        if (!parcelleService.getParcelleById(id).isPresent()) {
            return ResponseEntity.notFound().build();
        }

        parcelleService.deleteParcelle(id);
        return ResponseEntity.noContent().build();
    }
}