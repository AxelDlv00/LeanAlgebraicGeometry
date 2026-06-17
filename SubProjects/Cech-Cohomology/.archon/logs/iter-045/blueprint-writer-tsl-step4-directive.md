# Blueprint-writer directive — fix `Cohomology_CechHigherDirectImage.tex` for the `tile_section_localization` lane

## Chapter to edit
`blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex` (the consolidated chapter; it covers
`AlgebraicJacobian/Cohomology/QcohTildeSections.lean` among others).

## Strategy context (the slice that matters)
The keystone of Route B (Stacks 01I8, sheaf-axiom equalizer) is `qcoh_section_isLocalizedModule`. Its
load-bearing leaf `lem:tile_section_localization` ("per-tile section localisation at `f`") is the NEXT
prover target. The chain of supporting facts up to it is now FORMALIZED in Lean:

- `lem:tile_image_opens_identities` (Sub-lemma A, DONE) — image-opens identities of `ι = specAwayToSpec g`.
- `lem:modulesSpecToSheaf_smul_eq`, `lem:modulesRestrictBasicOpen_smul_eq` (the two rfl scalar bridges, DONE).
- `lem:isLocalizedModule_powers_restrictScalars_of_algebraMap` (base-ring descent, DONE).
- **iter-044 just landed 5 NEW axiom-clean Lean declarations** in `QcohTildeSections.lean` that are the
  route-(A) (ΓSpec-naturality) realisation of the residual ring identity of `lem:tile_section_comparison`.
  These 5 currently have **NO blueprint block** (coverage debt / unmatched nodes). They are:
  1. `AlgebraicGeometry.appTop_appIso_inv_eq_res` (line ~801) — general open-immersion lemma:
     `f.appTop ≫ (f.appIso ⊤).inv = Y.presheaf.map (homOfLE le_top).op`. Reads `appIso` as section-restriction.
  2. `AlgebraicGeometry.key_morph` (line ~815) — ΓSpec naturality of `specAwayToSpec g = Spec.map (algebraMap R R_g)`:
     `(ΓSpecIso R).inv ≫ ρ^{D(g)} = ofHom(algebraMap R R_g) ≫ (ΓSpecIso R_g).inv ≫ ((specAwayToSpec g).appIso ⊤).inv`.
     The morphism-level content of Γ-Spec naturality for the localisation map. (Most substantive of the five.)
  3. `AlgebraicGeometry.tile_appIso_comp` (line ~831) — `comp_appIso` bookkeeping folding the two tile section
     isos `(basicOpenIsoSpecAway g).inv.appIso` and `(specBasicOpen g).ι.appIso` into the single
     `(specAwayToSpec g).appIso ⊤`, up to a `presheaf.map (eqToHom …).op` correction.
  4. `AlgebraicGeometry.tile_section_ring_identity` (line ~847) — the assembled morphism-level ring identity
     (combines `key_morph` + `tile_appIso_comp` + a thin-cat restriction merge). This is the displayed ring
     identity `ρ^{D(g)}(θ_R(r)) = β_g^{-1}(θ_{R_g}(r̄))` of `lem:tile_section_comparison`'s proof, at morphism level.
  5. `AlgebraicGeometry.tile_scalar_compat` (line ~876) — the scalar-compatibility lemma at `V = ⊤`:
     for `r ∈ R` and a section `x` of `F` over the tile image `D(g)`, `r • x` (as an `R`-module section)
     equals `(algebraMap R R_g r) • x` (as an `R_g`-module section of the tile). NOT an isomorphism, NOT
     equal to `lem:tile_section_comparison`. Proof: the two rfl bridges + `congr 1` + `tile_section_ring_identity`
     applied elementwise (needs `set_option maxHeartbeats 1000000`).

The authoritative description of all five (signatures, what each relies on) is in the prover report
`.archon/task_results/QcohTildeSections.md` (sections "tile_scalar_compat … RESOLVED", "Supporting lemmas",
"Needs blueprint entry"). You may READ that file and the Lean file directly to get the exact signatures.

## What is WRONG with the chapter right now (must fix — flagged by lean-vs-blueprint-checker `qts`, 5 major)

1. **Coverage debt: the 5 new Lean decls have no blueprint blocks.** Author one `\begin{lemma}…\end{lemma}`
   block per decl (statement in project notation, `\label{…}`, `\lean{AlgebraicGeometry.<name>}`, accurate
   `\uses{}`, and a short informal proof). Place them in the `TileSectionLocalization` section, BEFORE
   `lem:tile_section_comparison` (whose proof cites them). Suggested labels:
   `lem:appTop_appIso_inv_eq_res`, `lem:key_morph`, `lem:tile_appIso_comp`, `lem:tile_section_ring_identity`,
   `lem:tile_scalar_compat`. Wire each one's `\uses{}` to the facts its Lean proof actually needs (see the
   report's per-decl "Relies on:" lines — e.g. `key_morph` uses `appTop_appIso_inv_eq_res` + the
   Mathlib `Scheme.ΓSpecIso_inv_naturality`/`specAwayToSpec_eq`; `tile_section_ring_identity` uses
   `key_morph` + `tile_appIso_comp`; `tile_scalar_compat` uses the two smul bridges +
   `tile_section_ring_identity`). For the Mathlib facts (ΓSpecIso naturality etc.) you do NOT need to add
   anchors — cite them in prose; only add `\uses{}` to project blocks that already exist.

2. **`lem:tile_section_comparison` proof sketch is misleading (Q1, Q2).** Revise it to:
   (a) Make explicit that "the carriers coincide" means **equality of the underlying section TYPE only**
       (via `lem:restrict_obj_mathlib`, keeping the F-side open in iterated-image form `W`), and that the
       **bundled module structure does NOT coincide definitionally** — `modulesSpecToSheaf.obj` is an
       `R_g`-module on the tile side vs an `R`-module on the F side (kernel-confirmed: the two are different
       `ModuleCat`s, not the same type at the bundled level). Drop any unqualified "the carrier and scalar
       bookkeeping above is definitional" claim — replace with the precise statement that the *scalar
       actions* reduce by the two rfl bridges and the *underlying carriers* coincide, but the bundled-module
       reconciliation requires the ring identity below.
   (b) Name the route-(A) helper chain: the residual ring identity is realised in Lean as
       `lem:tile_section_ring_identity` (assembled from `lem:key_morph` + `lem:tile_appIso_comp`), and the
       scalar-compatibility corollary at `V = ⊤` is `lem:tile_scalar_compat`. Add these to the proof's
       `\uses{}`.
   (c) Do NOT add a `\lean{}` pin to `lem:tile_section_comparison` itself — it remains an UNFORMALIZED
       assembly target (the full natural `R_g`-linear iso over all `V` has not been built; only its scalar
       core at `V = ⊤`, `tile_scalar_compat`, exists). Leave it unpinned, with a one-line `% NOTE` saying so.

3. **`lem:tile_section_localization` Step 4 is the critical fix (Q4).** It currently reads "By
   Lemma~\ref{lem:tile_section_comparison} there is an `R_g`-linear isomorphism …" — but
   `lem:tile_section_comparison` has no `\lean{}` and is NOT a Lean declaration, so a prover would search for
   it and fail. Rewrite Step 4 to describe the ACTUAL implementation path the prover will take (this is the
   path in the prover handoff note, `.archon/task_results/QcohTildeSections.md`, "tile_section_localization
   — NOT ADDED … Next step (precise)"):
   - Work at the **underlying section type** (`F.val`/carrier) level, NOT the bundled `modulesSpecToSheaf.obj`
     level (kernel-confirmed: the bundled carriers are different `ModuleCat`s — `ModuleCat R_g` vs `ModuleCat R`).
   - On the underlying tile section type, install (via `letI`/transport) a `Module R` structure and an
     `IsScalarTower R R_g` instance. The `IsScalarTower` compatibility at the SOURCE open (`V = ⊤`, i.e.
     `W = D(g)`) is exactly `lem:tile_scalar_compat`.
   - **Acknowledge explicitly the V = D(f̄) gap the checker raised:** the localisation map runs from the open
     `V = ⊤` (→ `D(g)`) to the open `V = D(f̄)` (→ `D(gf)`). The base-ring descent needs the same
     scalar-tower compatibility at the TARGET open `V = D(f̄)` as well, not only at `V = ⊤`. State that
     `lem:tile_scalar_compat` as currently formalized covers only `V = ⊤`, so Step 4 additionally needs a
     `V = D(f̄)` analogue of the scalar compatibility. Describe how to obtain it: re-run the route-(A)
     ΓSpec-naturality argument (`lem:key_morph`/`lem:tile_section_ring_identity`) one localisation deeper, at
     the composed basic open `gf` (`D(f̄) ⊆ Spec R_g` corresponds to `D(gf) ⊆ Spec R`, and
     `Γ(D(gf),𝒪) = R_{gf}`), OR generalise `tile_scalar_compat` from `⊤` to an arbitrary basic open `V`.
     Whichever — make clear this is mechanical reuse of the SAME route-(A) machinery, not new mathematics.
   - Then descend the base ring with `lem:isLocalizedModule_powers_restrictScalars_of_algebraMap`, and
     transport the opens by `eqToHom` using `lem:tile_image_opens_identities`.
   - Update `lem:tile_section_localization`'s `\uses{}`: replace the dependence on `lem:tile_section_comparison`
     (unformalized) with the actual Lean ingredients — `lem:tile_scalar_compat` plus the two rfl bridges
     `lem:modulesSpecToSheaf_smul_eq`, `lem:modulesRestrictBasicOpen_smul_eq` — alongside the already-listed
     `lem:section_isLocalizedModule_of_presentation`, `lem:isLocalizedModule_powers_restrictScalars_of_algebraMap`,
     `lem:tile_image_opens_identities`, `lem:presentation_modulesRestrictBasicOpen`. Keep the existing
     `% NOTE` warning that the naive `restrict_obj`-rfl recipe is unsound.

## Out of scope (do NOT touch)
- Do NOT add or remove `\leanok` anywhere (the deterministic sync owns it).
- Do NOT add `\lean{}` to `lem:tile_section_comparison` (it stays unformalized).
- Do NOT touch the pre-existing coverage-debt items `isLocalizedModule_of_span_cover`,
  `isIso_fromTildeΓ_of_genSections`, `exists_finite_basicOpen_subcover` (separate, lower-priority pass).
- Do NOT rewrite the kernel-comparison / keystone / assembly blocks below `lem:tile_section_localization`.
- Do NOT edit any other chapter.

## Sources
The math is Stacks 01HV(4) / 01I8 (sections of a qcoh sheaf over `D(g)` localise; already cited in the
chapter). The five new blocks are project-bespoke Lean infrastructure (route-(A) ΓSpec-naturality
realisation) — they stand on their proof sketch; no external citation is needed beyond the in-prose
reference to ΓSpec naturality. `references/**` is in your write-domain in case you find you need a source.
