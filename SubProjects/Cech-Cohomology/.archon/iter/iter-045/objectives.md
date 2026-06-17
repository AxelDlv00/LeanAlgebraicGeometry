# Iter-045 objectives — detail

## Lane 1 (only): `QcohTildeSections.lean` → `tile_section_localization` [mathlib-build]

**Goal.** Build the new declaration `AlgebraicGeometry.tile_section_localization` (does not yet exist):
for `X = Spec R`, qcoh `F`, `f ∈ R`, and `g` a cover element / overlap product of the finite presentation
cover, `IsLocalizedModule (Submonoid.powers f)` of the restriction-of-sections map
`Γ(D(g),F) → Γ(D(gf),F)` (equivalently `Γ(D(g),F)_f ≅ Γ(D(gf),F)`). Plus any `tile_scalar_compat`-at-`D(f̄)`
helper the descent requires.

**Why it is ready.** All ingredients axiom-clean and present:
- B4 `presentationModulesRestrictBasicOpen` (iter-040) — global tile presentation over R_g.
- `section_isLocalizedModule_of_presentation` — `IsLocalizedModule(powers f̄) m_tile` over R_g.
- Sub-lemma A `tile_image_opens_identities` (iter-042) — `ι ''ᵁ ⊤ = D(g)`, `ι ''ᵁ D(f̄) = D(gf)`.
- `tile_scalar_compat` (iter-044) — scalar-tower compat at V=⊤ (= D(g)).
- two rfl bridges (iter-043) + base-ring descent `isLocalizedModule_powers_restrictScalars_of_algebraMap`
  (iter-041).

**The genuine remaining work (engineering, no math wall — blueprint Step 4):**
1. Descend at the UNDERLYING-type / `F.val` level (bundled `modulesSpecToSheaf.obj` carriers are different
   `ModuleCat`s — `ModuleCat R_g` vs `ModuleCat R` — kernel-confirmed iter-042/044).
2. `letI` `Module R` + `IsScalarTower R R_g` on the underlying tile section type. Source-open (V=⊤) compat
   IS `tile_scalar_compat`; **target-open (V=D(f̄)) compat needs a NEW analogue** — same route-(A)
   ΓSpec-naturality argument at `gf` (`Γ(D(gf),𝒪) = R_{gf}`), or a generalisation of `tile_scalar_compat`
   to an arbitrary basic open.
3. Feed R_g-linear `m_tile` to base-ring descent ⟹ `IsLocalizedModule(powers f)` over R.
4. Identify the descended map with `ρ_W : Γ_R(D(g),F)→Γ_R(D(gf),F)` via underlying carrier defeq + `eqToHom`
   opens transport.

**Stop condition (mathlib-build).** No sorry. If the descent stalls on a concrete term-mode wall (the
`Module R` transport onto the underlying tile type, or the `m_tile = ρ_W` map identity), leave a precise
decomposition + the actual error — next iter dispatches a mathlib-analogist on the
`restrictScalars`/`IsScalarTower` transport.

## Off-keystone: no second lane
`cech_augmented_resolution` (`cechAugmented_exact`) is GATED on 01I8 via `\uses{lem:qcoh_iso_tilde_sections}`
(frontier-honesty fix iter-043). All other files are DONE / frozen / read-only (see PROGRESS "Off-limits").

## Coverage debt status
- 5 iter-044 helper decls: CLEARED this iter (blueprint-writer `tsl-step4` authored blocks + `\lean{}` pins).
- 1 remaining unmatched: dead `CechAcyclic.affine` (pre-existing; deletion deferred — protected
  `CechHigherDirectImage.lean` references it).
- Pre-existing lower-priority debt (`isLocalizedModule_of_span_cover`, `isIso_fromTildeΓ_of_genSections`,
  `exists_finite_basicOpen_subcover`): deferred to a future blueprint pass (not on the critical path).
