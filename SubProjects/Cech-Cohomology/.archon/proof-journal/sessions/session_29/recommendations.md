# Recommendations — after iter-029 (for the iter-030 plan agent)

## CRITICAL — resolve the ⊤-vs-D(f) DESIGN FORK before any Lane-1 re-dispatch
`affineCoverSystem` cannot be built until `injective_acyclic` and `surj_of_vanishing` cover standard covers of
**arbitrary distinguished opens `D(f)`**, not just `⊤ = Spec R`. The L4 induction
(`absoluteCohomology_eq_zero_of_basis`) applies these fields at the faces `⨅ₖ c.2(σk)` (sub-`D(f)`s), so `Cov`
must contain covers of every `D(f)`. The landed `affine_injective_acyclic` only handles `⊤`.
- **Recommended route:** relativize `injective_cech_acyclic` (CechBridge) to covers of an arbitrary open `W`
  — i.e. resolve `freeYoneda W` instead of `freeYoneda ⊤` in the free Čech resolution
  (FreePresheafComplex). Then `affine_injective_acyclic` generalizes via `coverOpen_affineOpenCoverOfSpan` +
  `funext` over `D(g_i) ⊆ D(f)`. This is a CechBridge/FreePresheafComplex change, **not** an
  `AffineSerreVanishing.lean` change — scope the prover lane accordingly.
- Alternative: treat each `D(f) ≅ Spec R_f` as its own affine (re-introduces a restriction step; likely worse).
- **Action:** make this a STRATEGY.md decision + (if relativization chosen) a dag/effort-break on the
  relativized `injective_cech_acyclic` BEFORE sending a prover at `affineCoverSystem`.

## HIGH — do NOT re-dispatch these four blocked targets as re-exports
The prover exhausted the search routes; they need new mathematics, not another tactic pass:
1. **`standard_cover_cofinal`** — no Mathlib cofinality lemma. Build from `Scheme.isBasis_affineOpens` +
   `OpenCover.finiteSubcover` (`D(f)` quasi-compact ⇒ finite basic-open refinement). **Co-design with
   `affine_surj_of_vanishing`** so the cofinality output is in the exact shape that consumer wants (consult
   `references/stacks-sheaves.tex` Tag 009L `lemma-cofinal-systems-coverings-standard-case`).
2. **`affine_surj_of_vanishing`** — needs `standard_cover_cofinal` + a usable "epi of `O_X`-modules ⇒ local
   section surjectivity along a basic-open refinement" lemma. Dead-end avoided by the prover: do NOT discharge
   from `injective_cech_acyclic` (the field's `S.X₁` is a quotient module, not injective).
3. **`affineCoverSystem`** — blocked on #1, #2, and the design fork above.
4. **Unconditional `qcoh_iso_tilde_sections`** (Lane 2) — blocked on the single instance
   `[IsQuasicoherent F] → IsIso F.fromTildeΓ` (Stacks 01I8 affine global generation, ~few-hundred LOC). Both
   the essImage and global-presentation routes verified to dead-end at the same gluing step. The conditional +
   presentation forms are shipped and axiom-clean; the qcoh upgrade is mechanical once the instance lands.
   If pursued, the prover needs the affine global-generation theorem (Hartshorne II.5.16 / 01I8): qcoh on
   `Spec R` ⇒ `F.GeneratingSections` (global epi `free I ⟶ F`) via `Spec R` compactness + partition-of-unity
   over the basic-open cover + localisation-of-sections. Consider `mathlib-analogist` (api-alignment) on
   whether any of this exists before committing a long lane.

## HIGH — root imports (refactor; provers can't edit root)
Both new files are orphaned from `AlgebraicJacobian.lean` (lean-auditor: 2 major). Add:
- `import AlgebraicJacobian.Cohomology.AffineSerreVanishing`
- `import AlgebraicJacobian.Cohomology.QcohTildeSections`
**Before** importing `QcohTildeSections.lean`: narrow its `import Mathlib` to
`import Mathlib.AlgebraicGeometry.Modules.Tilde` (+ any others actually used) — a whole-library import in the
build graph is a build-cost regression (lean-auditor minor). A `refactor` lane should do both in one pass.

## MEDIUM — blueprint reconciliation (HARD-GATE prerequisite before the next 02KG/assembly prover)
Four review `% NOTE:`s were added this iter flagging Lean↔blueprint divergences; the planner's blueprint-writer
should reconcile the *prose* (the NOTEs only document; they don't fix the statements):
1. `lem:cover_datum_bridge` — repin `\lean{}` to `coverOpen_affineOpenCoverOfSpan` + revise statement to the
   open-level equality, OR keep the full complex-identification as a pending target with a fresh block for the
   open-level helper. (Dangling pin to nonexistent `coverDatum_bridge`.)
2. `lem:affine_injective_acyclic` — narrow prose to the ⊤-cover scope; add the relativization plan.
3. `def:affine_cover_system` — mark NOT-YET-BUILDABLE pending the design fork.
4. `lem:qcoh_iso_tilde_sections` — proof-block prose sketches the *unconditional* proof while the Lean is the
   conditional one-liner; supplement with a short conditional-form note (lvb `qcoh` rec #2). Optionally backfill
   the 3-step 01I8 decomposition from the file's `## Handoff` into the chapter (lvb `qcoh` rec #3).

## MEDIUM — coverage debt (unmatched lean_aux = 5; planner blueprints these)
`archon dag-query unmatched` → 5 nodes:
- `AlgebraicGeometry.coverOpen_affineOpenCoverOfSpan` (AffineSerreVanishing) — open-level cover bridge;
  relies on `Scheme.affineOpenCoverOfSpanRangeEqTop`, `Spec.map_base`,
  `PrimeSpectrum.localization_away_comap_range`, project `coverOpen`. → bundle into `lem:cover_datum_bridge`'s
  `\lean{...}` (see reconcile #1).
- `AlgebraicGeometry.qcoh_iso_tilde_sections_of_presentation` (QcohTildeSections) — presentation-form discharge;
  relies on Mathlib `isIso_fromTildeΓ_of_presentation`. → deserves its OWN block (lvb `qcoh` rec #1).
- `AlgebraicGeometry.qcoh_iso_tilde_sections_hom`, `_inv` (QcohTildeSections) — `@[simp]` accessors; bundle into
  `lem:qcoh_iso_tilde_sections`'s `\lean{...}` list.
- `AlgebraicGeometry.CechAcyclic.affine` — the DEAD superseded relative-form decl (carries a sorry; de-pinned
  from `lem:cech_acyclic_affine` this iter). **Consider deleting it** (a refactor lane) to drop project sorry
  2→1 and clear the unmatched node; it has no rdeps.

## LOW
- Stray temp file `_mcp_snippet_3ec85537f4f442528204096df4bbf3da.lean` at the repo root — clean up (a refactor
  lane, or `git clean`); it is not part of the build.

## Reusable proof patterns discovered this iter (added to PROJECT_STATUS Knowledge Base)
- **Standard-cover member opensRange = D(s_i)**: `unfold coverOpen; change …opensRange; Opens.ext;
  rw [Spec.map_base]; exact PrimeSpectrum.localization_away_comap_range (Localization.Away (s i)) (s i)`.
- **faces_mem via basicOpen_sprod**: `⟨∏ k, s (σ k), (basicOpen_sprod (p+1) s σ).symm⟩` (membership-in-range shape).
- **Finite I₀ through AffineOpenCover doesn't auto-synthesize**: supply `haveI : Finite (…).openCover.I₀ :=
  inferInstanceAs (Finite ι)`.
- **Affine structure theorem, conditional form**: `(asIso F.fromTildeΓ).symm` with `[IsIso F.fromTildeΓ]`;
  discharge via `isIso_fromTildeΓ_of_presentation F P` for a global presentation. Mathlib handles:
  `Scheme.Modules.fromTildeΓ`, `isIso_fromTildeΓ_iff`, `isIso_fromTildeΓ_of_presentation`
  (`Mathlib/AlgebraicGeometry/Modules/Tilde.lean`). `IsQuasicoherent F` → only local `QuasicoherentData`.
- **Namespace gotcha**: `affineOpenCoverOfSpanRangeEqTop` lives under `Scheme` (not bare); `.openCover` gives
  the `X.OpenCover`.
