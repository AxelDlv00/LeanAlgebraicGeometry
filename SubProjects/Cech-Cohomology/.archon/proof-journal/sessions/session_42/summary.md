# Session 42 (iter-042) — review summary

## Metadata
- **Iteration / session:** iter-042 / session_42
- **Prover model:** claude-opus-4-8 (mode: `mathlib-build`)
- **Lanes planned / ran:** 1 / 1 (`QcohTildeSections.lean`)
- **Total inline sorry:** 2 → 2 (no change; both frozen/superseded — dead `CechAcyclic.affine`, frozen P5b).
  Prover file `QcohTildeSections.lean` remains 0-sorry.
- **Build:** GREEN. `lake build AlgebraicJacobian.Cohomology.QcohTildeSections` EXIT 0; new lemma
  `lean_verify` axioms = `{propext, Classical.choice, Quot.sound}`.
- **Net declarations:** +1 axiom-clean (`tile_image_opens_identities`, Sub-lemma A). The named target
  `tile_section_localization` was NOT formalized (deferred — honest stop, no sorry papered).

## Headline — Sub-lemma A landed; Sub-lemma B (the genuine cost) confirmed non-definitional under a clean build
The planner's iter-042 lane re-dispatched `tile_section_localization` (the last keystone leaf) with the
iter-041 must-fix on its sketch already fixed (honest 5-step base-ring descent). The prover landed the
cheap half — **Sub-lemma A `tile_image_opens_identities`** (the affine-tile image-opens identities
`ι ''ᵁ ⊤ = D(g)`, `ι ''ᵁ D(f̄) = D(gf)`) axiom-clean — and then **definitively confirmed the iter-041
finding** that the descent's other half (Sub-lemma B, `tile_section_comparison`) is genuinely
non-definitional. This is the project-memory `[[keystone-tile-reconciliation-not-rfl]]` trap, now nailed
down at the kernel level rather than just in the LSP.

## Target 1 — `tile_image_opens_identities` (Sub-lemma A) — SOLVED, axiom-clean
- **Statement:** for `g f : R`, the two iterated image opens of the affine identification
  `ι = specAwayToSpec g`:
  - `(specBasicOpen g).ι ''ᵁ ((basicOpenIsoSpecAway g).inv ''ᵁ ⊤) = specBasicOpen g`
  - `(specBasicOpen g).ι ''ᵁ ((basicOpenIsoSpecAway g).inv ''ᵁ basicOpen (algebraMap R R_g f)) = specBasicOpen (g*f)`
- **Final proof structure:**
  - Identity 1: `Scheme.Hom.image_top_eq_opensRange` + `Scheme.Hom.opensRange_of_isIso` (inv of an iso
    has full opensRange), then `simp [image_top_eq_opensRange]`.
  - Identity 2: a `have hcomp := (Scheme.Hom.comp_image _ _ _).symm` collapses the two `''ᵁ` into
    `specAwayToSpec g ''ᵁ -`; then `specAwayToSpec_eq` rewrites the map to `Spec.map (algebraMap)`, which
    on points is `PrimeSpectrum.comap (algebraMap R R_g)`. Membership computation:
    `comap '' basicOpen(algebraMap f) = basicOpen f ∩ range comap = basicOpen f ∩ basicOpen g = basicOpen (g*f)`.
- **Tactic dead-ends learned (in order):**
  1. `rw [← Scheme.Hom.image_comp]` / `Scheme.comp_image` — **wrong names**; the real lemma is
     `Scheme.Hom.comp_image` (namespace `Scheme.Hom`).
  2. `rw [← Scheme.Hom.comp_image]` directly on the goal — **"motive is not type correct"**
     (`IsOpenImmersion.coe` argument mismatch). Fix: stage the composition equality as a separate `have`
     and `rw` with that, rather than rewriting the dependent goal in place.
- **Result:** `#print axioms` kernel-only. Blueprint block `lem:tile_image_opens_identities` is now
  `\lean{}`-pinned (review-applied this iter — see Blueprint markers).

## Target 2 — `tile_section_localization` — BLOCKED (Sub-lemma B genuinely non-definitional)
- **Goal:** `IsLocalizedModule (powers f)` of the `R`-section restriction `Γ(D(g),F) → Γ(D(gf),F)` for a
  tile with a global presentation.
- **The skeleton is built and correct:** `section_isLocalizedModule_of_presentation (modulesRestrictBasicOpen g F) P (algebraMap f)`
  → `IsLocalizedModule (powers (algebraMap f))` over `R_g`; base-ring descent via
  `isLocalizedModule_powers_restrictScalars_of_algebraMap` (built iter-041); `tile_image_opens_identities`
  to rewrite the image opens. The single missing piece is the section-comparison transport (Sub-lemma B).
- **The blocker, proven this iter:** the two section modules are **not even the same type** —
  - `(modulesSpecToSheaf.obj (modulesRestrictBasicOpen g F)).presheaf.obj (op V) : ModuleCat ↑(Localization.Away g)`
  - `(modulesSpecToSheaf.obj F).presheaf.obj (op (ι ''ᵁ V)) : ModuleCat ↑R`

  `modulesSpecToSheaf` restricts scalars to the base ring of its Spec, so over `R_g` it lands in
  `ModuleCat R_g` and over `R` in `ModuleCat R`. Neither carriers nor the scalar coherence
  `algebraMap R R_g r • x = r • x` is `rfl`.
- **Every forcing attempt failed** (see milestones for code+errors): manual `inferInstanceAs`/`letI`
  R-module provision (type mismatch + `dependsOnNoncomputable`), `noncomputable def` (class type must be
  `@[reducible]`), `backward.isDefEq.respectTransparency false`, `synthInstance.maxHeartbeats`/`maxHeartbeats`
  up to 2e6 — none make a non-definitional comparison `rfl`.
- **Key process lesson (important):** the prover initially got the definitional-collapse route to compile
  via `lean_run_code`/LSP — **those successes were stale-`.olean` artifacts**. A clean `lake env lean` on a
  minimal external test (`CoherenceTest.lean`, since removed) gave the hard type mismatch. **Tile-section
  defeq claims must be confirmed with a fresh `lake env lean`, never trusted from `lean_run_code`/LSP.**
- **Honest stop:** no sorry was papered; the file stays 0-sorry, and a precise deferred-note block comment
  records the exact Sub-lemma B type/recipe for the next prover.

## Key findings / patterns
- **Stale-olean defeq trap (new):** `lean_run_code` and the LSP can report `rfl`/instance successes for
  cross-ring tile-section defeqs that a clean `lake env lean` rejects. Always confirm with a fresh full
  build on a minimal test file. (Added to Knowledge Base.)
- **`Scheme.Hom.comp_image` staging:** rewriting an iterated `''ᵁ` image equality in place fails on an
  ill-typed motive; stage the composition as a `have ... := (Scheme.Hom.comp_image _ _ _).symm` and `rw`
  with it. (Added to Knowledge Base.)
- **`specAwayToSpec_eq` + `PrimeSpectrum.comap` + `localization_away_comap_range`** is the working recipe
  for affine basic-open image computations on the localization morphism.

## Blueprint markers updated (manual)
- `Cohomology_CechHigherDirectImage.tex`, `lem:tile_image_opens_identities`: added
  `\lean{AlgebraicGeometry.tile_image_opens_identities}` and removed the stale
  `% NOTE: the \lean{} pin is deferred …` comment — the decl is now built + axiom-clean. (`\leanok` is
  left to the deterministic `sync_leanok`; it will add it next iter now that the pin exists. sync ran
  this iter at sha `2a2ff23` BEFORE the pin existed, so this block carries no `\leanok` yet — expected,
  not laundering.)

## Recommendations
See `recommendations.md`. Headline: build the honest Sub-lemma B (`tile_section_comparison`) — the natural
`R_g`-linear iso `Γ_{R_g}(V, F_{(g)}) ≅ Γ_R(ι ''ᵁ V, F)` — then assemble `tile_section_localization` via
the existing skeleton. Do NOT re-attempt the definitional-collapse route.
