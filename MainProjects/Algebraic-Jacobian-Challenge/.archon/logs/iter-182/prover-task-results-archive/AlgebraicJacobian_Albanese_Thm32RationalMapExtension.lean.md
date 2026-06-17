# AlgebraicJacobian/Albanese/Thm32RationalMapExtension.lean

## Iter-182 status overview

**File classification.** Per `PROGRESS.md` iter-182 prover phase, this file is
listed in `## Off-limits this iteration` and `## Standing deferrals` (gated
on `extend_of_codimOneFree_of_smooth` body landing in
`Albanese/CodimOneExtension.lean`, itself iter-184+ per Lane G PIVOT rationale
in `analogies/stacks-00tt-coheight.md`). The file was nonetheless assigned to
a prover lane this iter, so I pushed the structural refactor as far as the
gates permit and documented the residual gaps.

**Build state.** `lake env lean AlgebraicJacobian/Albanese/Thm32RationalMapExtension.lean`
clean: **2 warnings (`declaration uses sorry`) + 0 errors + 0 axioms**. Sorry
count UNCHANGED from iter-181 (2 → 2); the iter-182 work refactors the
proof structure of one sorry rather than reducing the count.

## Sorry inventory

### Sorry 1 — `av_isIntegral_of_smooth_geomIrred` (L176, body L194)
**Status: UNCHANGED iter-182 (Mathlib-gap).** Body of the helper unchanged;
the single inline `sorry` discharges `IsReduced A.left` from `[Smooth A.hom]`.

**The gap is genuine.** Search across the Mathlib at the project's pinned
commit found *no* bridge `Smooth f → IsReduced X`, `Smooth f → GeometricallyReduced f`,
`Algebra.Smooth K A → IsReduced A`, or
`Algebra.Smooth K A → Algebra.IsGeometricallyReduced K A`:

- `Mathlib/AlgebraicGeometry/Morphisms/Smooth.lean` has only
  `instance [Smooth f] : Flat f` (L113) and
  `Scheme.Hom.dense_smoothLocus_of_perfectField` (the *reverse* direction,
  requires `[IsReduced X]` as a hypothesis).
- `Mathlib/RingTheory/Smooth/Field.lean` only treats *field* extensions
  (`Algebra.FormallySmooth.of_perfectField` for `EssFiniteType` field
  extensions — does not apply to a general smooth `K`-algebra).
- `Mathlib/AlgebraicGeometry/Geometrically/Reduced.lean` requires
  `[GeometricallyReduced f]` as input — exactly what the missing bridge
  would provide.
- `Mathlib/RingTheory/Nilpotent/GeometricallyReduced.lean` defines
  `IsGeometricallyReduced k A` without a `Smooth → IsGeometricallyReduced`
  instance.

**Stacks reference:** the missing implication is **Stacks 034V** / **02G4**
("Smoothness over a perfect field implies geometrically reduced") — not
formalized at commit `b80f227`. The existing docstring on the lemma documents
this precisely; the iter-182 search confirms no alternative path through
Mathlib exists.

**Discharge path when the bridge lands.** Once `Smooth A.hom → IsReduced A.left`
or `Smooth f → GeometricallyReduced f` ships in Mathlib, the single sorry
discharges via either:
1. `haveI : IsReduced A.left := inferInstance` (if `Smooth → IsReduced`
   direct), OR
2. The chain `Smooth A.hom → Flat A.hom + GeometricallyReduced A.hom`,
   combined with `IsReduced (Spec kbar)` (field is reduced) +
   `IsLocallyNoetherian (Spec kbar)` (field is noetherian), via
   `GeometricallyReduced.isReduced_of_flat_of_isLocallyNoetherian` (already
   in Mathlib).

The helper then becomes axiom-clean automatically — no further project work
needed at this file.

### Sorry 2 — `av_codimOneFree_of_indeterminacy` (L233, body L283)
**Status: REFACTORED iter-182. Branch 1 CLOSED inline; branch 2 isolated.**

**Iter-182 structural refactor.** The previous body was a bare top-level
`sorry`. I rewrote the body to:

1. Materialise the variety-package instances on `A.left` required by
   `indeterminacy_pure_codim_one_into_grpScheme` (`IsIntegral` via the
   split helper `av_isIntegral_of_smooth_geomIrred`; `IsReduced` via
   `isReduced_of_isIntegral`; `IsSeparated` from `IsProper`;
   `LocallyOfFiniteType` from `Smooth`).
2. Invoke `indeterminacy_pure_codim_one_into_grpScheme f` to obtain the
   disjunction `indeterminacyLocus f = ∅ ∨ ∀ x ∈ Z, ∃ z, coheight z = 1 ∧ x ∈ closure {z}`.
3. `intro x hx` and split on the disjunction:
   - **Branch 1 (CLOSED).** `indeterminacyLocus f = ∅`: contradiction via
     `Set.not_mem_empty`-style argument. Axiom-clean.
   - **Branch 2 (sorry).** Codim-1 indeterminacy disjunct — requires the
     codim-≥2 conclusion of Milne 3.1 (currently encapsulated inside
     `extend_of_codimOneFree_of_smooth`'s `sorry`'d body in
     `Albanese/CodimOneExtension.lean`).

The branch-1 logic is additionally extracted as a standalone axiom-clean
helper `codimOneFree_of_indeterminacyLocus_eq_empty` (file-level), so the
structural split survives any future refactor of the parent helper.

**Discharge path for branch 2.** Once `CodimOneExtension.lean` exposes a
standalone lemma

```
theorem indeterminacy_codimGe2_of_smooth_of_complete
    [variety/proper hypotheses]
    (f : X.RationalMap Y) : ∀ z ∈ indeterminacyLocus f, Order.coheight z ≥ 2
```

(the unbundled codim-≥2 half of Milne 3.1), branch 2 closes via:

```
by_contra hnotin
obtain ⟨z, hz1, hxz⟩ := hpure x hnotin
-- T0/sobriety + equal coheight 1 + specialization ⟹ x = z
obtain rfl := <sober equality from hxz, hx, hz1>
exact absurd hz1 (by linarith [codimGe2 hnotin])
```

This is precisely what the iter-184+ Lane G follow-up on
`CodimOneExtension.lean` (per `analogies/stacks-00tt-coheight.md`) will
deliver.

## Auxiliary scaffolding landed iter-182

- New private lemma `codimOneFree_of_indeterminacyLocus_eq_empty` (L290):
  axiom-clean, captures the branch-1 logic standalone.

## Search log (negative results)

The following Mathlib searches returned no matches for the missing bridges:

- `grep "Smooth.*[Ii]sReduced|isReduced.*[Ss]mooth"` in
  `Mathlib/AlgebraicGeometry/` and `Mathlib/RingTheory/`: nothing.
- `grep "Smooth.*GeometricallyReduced|GeometricallyReduced.*Smooth"`:
  nothing.
- `grep "Smooth.*reduced"` (case-insensitive): nothing.
- `grep "034V|02G4"` (Stacks tags): nothing.
- `lean_local_search "indeterminacy_pure"`: nothing
  (lemma name verified to exist in `CodimOneExtension.lean:397`; the
  local-search index lag is benign).

Confirms the gap is genuine Mathlib-upstream content, not a lookup miss.

## Dead-end warnings for future provers

1. **Do NOT try `instance IsGeometricallyReduced kbar A` from `Smooth`**:
   no such instance exists in Mathlib; declaring one would itself be a
   substantive Mathlib contribution (Stacks 034V/02G4).
2. **Do NOT try to close branch 2 of `av_codimOneFree_of_indeterminacy`
   without `indeterminacy_codimGe2_of_smooth_of_complete`**: the disjunction
   from Milne Lemma 3.3 alone is insufficient (the codim-1 disjunct is
   consistent with a codim-1 point in the indeterminacy locus, and the
   contradiction needs the orthogonal codim-≥2 codimension bound).
3. **Do NOT split `av_isIntegral_of_smooth_geomIrred` further**: the proof
   body is already minimally factored (3-step Stacks chain with the single
   missing implication isolated as a `sorry`'d `haveI`).

## Blueprint marker handoff (for review agent)

Both pinned declarations (`extend_to_av` L365 and the two split helpers
`av_isIntegral_of_smooth_geomIrred` L176 + `av_codimOneFree_of_indeterminacy`
L233 + the wrapper `av_isIntegral_and_codimOneFree` L312) compile and carry
the substantive (non-tautological) type signatures. The new helper
`codimOneFree_of_indeterminacyLocus_eq_empty` L290 is sorry-free; the parent
`av_codimOneFree_of_indeterminacy` is `sorry`-containing on branch 2; both
upstream helpers have inline `sorry`'s on their substantive content.

The blueprint chapter `chapters/Albanese_Thm32RationalMapExtension.tex`
should NOT change `\leanok` status this iter (sorries unchanged); the
`sync_leanok` deterministic phase between prover and review will handle
markers correctly based on actual sorry counts.

## Next-iter handoff

**iter-183+ work on this file:** stay deferred until `CodimOneExtension.lean`
lands the codim-≥2 standalone lemma (gated on Lane G iter-183+ post-
CoheightBridge), at which point the branch-2 sorry in
`av_codimOneFree_of_indeterminacy` closes via the snippet above (~10 LOC).

**iter-???+ work on this file:** when Mathlib ships Stacks 034V (smooth over
perfect field ⟹ geometrically reduced), the single sorry in
`av_isIntegral_of_smooth_geomIrred` discharges via `inferInstance` and the
file becomes axiom-clean automatically.

Both pickup points reduce to a single `inferInstance` line plus a ~10-line
contradiction argument; the file structure is fully prepared.
