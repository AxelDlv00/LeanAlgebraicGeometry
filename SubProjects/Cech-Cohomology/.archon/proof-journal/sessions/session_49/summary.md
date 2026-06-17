# Session 49 (iter-049) — review summary

## Metadata
- **Sorry count:** 2 → 2 (no regression). Both frozen/superseded:
  `CechHigherDirectImage.lean:679` (protected P5b main theorem), `CechAcyclic.lean:110` (dead `affine`).
  The `CechAcyclic.lean:18` grep hit is a doc-comment, not a real sorry. The new file
  `AffineSerreVanishing.lean` is 0-sorry.
- **Build:** GREEN (`lake env lean` EXIT 0; full `lake build` 8332 jobs, exit 0 — only longLine/maxHeartbeats
  style warnings).
- **Targets attempted:** Lane 1 (`AffineSerreVanishing.lean` — `affine_cech_vanishing_qcoh` +
  `affine_serre_vanishing`) ran and produced output; Lane 2 (`CechHigherDirectImage.lean` —
  `cechAugmented_exact`) was dispatched by the planner but **no prover ran on it** this iter (only one
  prover log exists).
- **Result:** Lane 1 PARTIAL — **+4 axiom-clean declarations, 0 new sorries.** Two blueprint targets
  reduced to a single explicit residual hypothesis `htilde`; not formalized as the blueprint-named decls.

## Lane 1 — `AffineSerreVanishing.lean` (partial, +4 axiom-clean)

The prover built the entire Lane-1 assembly **conditional on one residual** and closed the first sub-leaf
of that residual. First-hand `lean_verify` on both top decls = `{propext, Classical.choice, Quot.sound}`.

### `affine_cover_span_localizationAway` — SOLVED (the R_f spanning leaf)
For a finite family `g : ι → R` with `D(f) = ⨆ᵢ D(gᵢ)`, the images `gᵢ ↦ R_f = Localization.Away f` span
the unit ideal of `R_f`.
- **Proof:** `rw [← PrimeSpectrum.iSup_basicOpen_eq_top_iff]; simp only [← PrimeSpectrum.comap_basicOpen];
  rw [← map_iSup, ← hcov, PrimeSpectrum.comap_basicOpen, eq_top_iff]; rintro p -;
  rw [PrimeSpectrum.mem_basicOpen]; exact fun hmem => p.isPrime.ne_top (Ideal.eq_top_of_isUnit_mem _ hmem
  (IsLocalization.Away.algebraMap_isUnit f))`.
- **Key insight:** the comap of the cover `⨆D(gᵢ)=D(f)` pulls back to `D(f)` in `Spec R_f`, which is `⊤`
  because `f` is a unit in `R_f`. This is exactly the first sub-leaf of the residual decomposition.

### `cechCohomology_isZero_of_iso` — SOLVED (reusable coefficient-iso transport)
- **Proof:** `h.of_iso ((HomologicalComplex.homologyFunctor Ab _ p).mapIso
  ((sectionCechComplexFunctor U).mapIso e)).symm`.
- Reusable: transports `IsZero (cechCohomology U F p)` along ANY coefficient iso `e : F ≅ G`.
  `sectionCechComplexFunctor.obj F = sectionCechComplex U F` definitionally.

### `affine_cech_vanishing_qcoh_of_tildeVanishing` — REDUCED form (modulo `htilde`)
The blueprint **seed**. Transports `HasVanishingHigherCech (affineCoverSystem R) F` to the tilde case via
the now-unconditional `(qcoh_iso_tilde_sections F).symm` (iter-048 instance
`isIso_fromTildeΓ_of_quasicoherent`), bottoming out at `htilde`.
- **Proof:** `intro c hc p hp; obtain ⟨n, g, f, rfl, hcov⟩ := hc; refine cechCohomology_isZero_of_iso _
  ((Scheme.Modules.toPresheafOfModules (Spec R)).mapIso (qcoh_iso_tilde_sections F).symm) p ?_;
  exact htilde n g f hcov p hp`.

### `affine_serre_vanishing_of_tildeVanishing` — REDUCED form (modulo `htilde`)
The blueprint **top**. Instantiates `cech_eq_cohomology_of_basis (affineCoverSystem R) (seed …)` at the
whole affine `⊤ = D(1)`. Verifies the full Lane-1 assembly typechecks end-to-end modulo `htilde`. Carries
`[EnoughInjectives (Spec R).Modules]`.
- **Lean-engineering note:** `Ext` resolution forced reactivating `attribute [local instance] hasExtModules`
  (line 30) — same file-local `HasExt.standard` instance as `AbsoluteCohomology.lean` — to dodge a slow
  `HasSmallLocalizedHom` typeclass search (deterministic 20000-heartbeat timeout otherwise). Also had to
  spell `CategoryTheory.Abelian.Ext` fully-qualified in the signature (an unqualified `Ext` triggered an
  overload-resolution timeout). lean-auditor confirmed the local-instance reactivation is benign.

## The single residual `htilde` (THE next leaf for Lane 1)
Both blueprint targets bottom out at: *positive-degree section Čech vanishing of the tilde sheaf `~M`
(`M = moduleSpecΓFunctor.obj F`) over a standard cover of a **proper** distinguished open `D(f)`* (NOT all
of `Spec R`). This is **not** `sectionCech_affine_vanishing` (CechAcyclic) — that needs `Ideal.span(range
s) = ⊤`, i.e. a cover of all of `Spec R`. The standard fix (Stacks 02KG /
`lemma-cech-cohomology-quasi-coherent-trivial`, "Write `U = Spec(A)`") is **change of base to `R_f =
Localization.Away f`**: each section is already an `R_f`-module, and over `R_f` the family `{gᵢ/1}` spans
`⊤` (the just-closed `affine_cover_span_localizationAway`). The heavy remaining work is a **change-of-space
iso of section Čech cochain complexes** `sectionCechComplex (D_R gᵢ) (~_R M) ≅ sectionCechComplex (D_{R_f}
gᵢ/1) (~_{R_f} M_f)`, after which `sectionCech_affine_vanishing` over `R_f` closes it. NB the `CechAcyclic`
module-level machinery (`sectionToModuleAddEquiv`, `dDiff_exact`, `phi`, `dCoeff`) is `private`, so an
`R_f`-direct re-derivation is not available — the public `sectionCech_affine_vanishing` forces the
change-of-space route.

## Lane 2 — `cechAugmented_exact` (not started)
Dispatched by the planner (P5a infra, independent of 02KG) but **no prover ran** on
`CechHigherDirectImage.lean` this iter: only the AffineSerreVanishing prover produced a log/task_result.
`cechAugmented_exact` remains absent. The `cechAugmented` strings in the combined prover log are the Lane-1
prover reading PROGRESS.md, not Lane-2 work. (Whether the loop intentionally serialized to one prover or
Lane 2 silently failed to launch is not determinable from the logs; flagged for the planner.)

## Review subagents
- **lean-auditor `iter049`** — clean: 0 must-fix, 0 major, 2 minor. Confirmed `htilde` is a **genuine
  non-vacuous obligation** (quantifies over all finite covers of all distinguished opens, asserts `IsZero`
  on a concrete Čech complex, is actually consumed at line 453, no sorry substitute — the reductions are
  NOT vacuously true). `attribute [local instance] hasExtModules` benign. No kernel-soundness trap. Two
  minor `set_option maxHeartbeats` overrides (lines 220, 363, pre-existing). Report:
  `task_results/lean-auditor-iter049.md`.
- **lean-vs-blueprint-checker `iter049-asv`** — Lean is faithful scaffolding (no placeholders/sorries/axioms;
  the two reduction lemmas are correct conditional reductions). Findings are **blueprint-side (planner
  domain)**: 1 must-fix — `lem:affine_cech_vanishing_qcoh`'s proof sketch ("apply `lem:cech_acyclic_affine`
  to `~M` over any standard cover") is INCOMPLETE: it omits the change-of-base-to-`R_f` step the Lean
  `htilde` makes explicit; `affine_cover_span_localizationAway` is unmentioned. 4 major: two `\lean{}` pins
  (`affine_serre_vanishing`, `affine_cech_vanishing_qcoh`) point at declarations that do **not yet exist**
  (aspirational); two unblueprinted reduction lemmas. Report:
  `task_results/lean-vs-blueprint-checker-iter049-asv.md`.

## Blueprint markers updated (manual)
- `Cohomology_CechHigherDirectImage.tex`, `lem:affine_serre_vanishing`: added `% NOTE` (iter-049) recording
  that the formalized form is `affine_serre_vanishing_of_tildeVanishing` (reduced, modulo `htilde`); the
  `\lean{}` pin is aspirational until `htilde` lands.
- `Cohomology_CechHigherDirectImage.tex`, `lem:affine_cech_vanishing_qcoh`: added `% NOTE` (iter-049)
  recording the reduced form `affine_cech_vanishing_qcoh_of_tildeVanishing` AND flagging the must-fix —
  the proof sketch omits the change-of-base-to-`R_f` step (the `htilde` residual / new helper
  `affine_cover_span_localizationAway`).
- No `\lean{...}` rename applied: the aspirational pins are correct target names, not renames — leave them
  unmatched/unproved (sync_leanok correctly left both target blocks without `\leanok`).
- I did NOT add or remove any `\leanok`. `sync_leanok` ran iter-049 (sha `6acf2d5`, +0/−2).

## Coverage debt (`dag-query unmatched` = 5)
1 pre-existing dead (`CechAcyclic.affine`) + 4 new lean_aux this iter. See `recommendations.md` for the
blueprint placement of the 4 new decls.

## Notes
- blueprint-doctor: no structural findings (every chapter `\input`'d, all `\ref`/`\uses` resolve, no
  `axiom` decls).
