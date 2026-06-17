# iter-078 objectives

## Lane 1 — `CechToHigherDirectImage.lean` (consumer signature thread)

Target: `cech_computes_higherDirectImage_of_affineCover` (line 197) — make it type-check. No `sorry` in
the file; this is a signature/call fix, not a fill.

Producer sig it must match (`CechTermAcyclic.lean:699–705`):
```
cechTerm_pushforward_acyclic [HasInjectiveResolutions X.Modules]
    (f : X ⟶ S) [QuasiCompact f] [IsSeparated f] [X.IsSeparated] [S.IsSeparated]
    (𝒰 : X.OpenCover) [Finite 𝒰.I₀] (h𝒰 : ∀ i, IsAffine (𝒰.X i))
    (F : X.Modules) (hF : F.IsQuasicoherent) (p : ℕ)
    (hres : ∀ σ : Fin (p + 1) → 𝒰.I₀,
      HasInjectiveResolutions (Scheme.Opens.toScheme (coverInterOpen 𝒰 σ)).Modules) : …
```

Edits:
1. Sig: drop `[X.IsSeparated]`; add `[S.IsSeparated]`; add binder
   `(hres : ∀ (n : ℕ) (σ : Fin (n + 1) → 𝒰.I₀), HasInjectiveResolutions (Scheme.Opens.toScheme (coverInterOpen 𝒰 σ)).Modules)`.
2. Body line 1: `haveI : X.IsSeparated := .mk (by have h : terminal.from X = f ≫ terminal.from S := terminal.hom_ext _ _; rw [h]; infer_instance)`.
3. Line 207 call: append `(hres n)`.
4. Optional: refresh docstrings (L16–22, L188–196).

Verify: `lake build AlgebraicJacobian.Cohomology.CechToHigherDirectImage`; build-wall → land + report;
review-build gate confirms. Axiom-clean check on the decl's cone (excludes the user-owned frozen sorry).

Expected outcome: capstone PROVED under correct hypotheses ⇒ Route A complete; only the frozen
false-signature `sorry` remains (user-owned) ⇒ project ready for polish stage.
