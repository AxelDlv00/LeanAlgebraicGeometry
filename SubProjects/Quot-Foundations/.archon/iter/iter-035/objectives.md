# Iter 035 — Objectives (Quot-Foundations)

Three import-independent prover lanes. Per-lane recipe + the iter-034 prover handoffs.

## Lane 1 — FBC-A `_legs` conjugate route (fine-grained)
File: `AlgebraicJacobian/Cohomology/FlatBaseChange.lean`.
The STUCK lane's last authorized attempt on the conjugate encoding (progress-critic `iter035`: one
round + effort-breaker = adequate iter-035 corrective; iter-036 pre-committed to the comparison-object
refactor). The effort-breaker `fbc-legs` atomized conj-1+conj-2 into the chain conj-1a (re-cut codomain
read `leftAdjointCompIso`-native) → conj-1b (bridge new↔old read) → conj-2a (restate) → conj-2b
(pullbackComp leg) → conj-2c (pushforward collapse) → conj-2d (cross-layer `gammaPushforwardIso`
transport) → conj-2e (assemble). Recipe: `analogies/fbc-mate-reencode.md` "Top suggestion".

## Lane 2 — QUOT gap1 keystone D (mathlib-build)
File: `AlgebraicJacobian/Picard/QuotScheme.lean`. Build
`AlgebraicGeometry.Scheme.Modules.isLocalizedModule_basicOpen_descent` (`lem:section_localization_descent`).
Source-verified to Stacks `lemma-invert-f-sections` (NOT the unverified "01HA"). Recipe = finite sheaf
equalizer over the basic-open cover + localization-is-flat; consumes the general
`isIso_fromTildeΓ_presentationPullback` (landed iter-034) per cover member +
`exists_finite_basicOpen_cover_le_quasicoherentData` + `isIso_fromTildeΓ_iff_isLocalizedModule_restrict`
(both in-file).

## Lane 3 — GR properness (mathlib-build / scaffold)
File: `AlgebraicJacobian/Picard/GrassmannianCells.lean`. Build
`AlgebraicGeometry.Grassmannian.isProper : IsProper (toSpecZ d r)` (`lem:gr_proper`). Mathlib API
confirmed: `IsProper.mk` needs `[IsSeparated]` (DONE = `isSeparatedToSpecZ`) + `[UniversallyClosed]` +
`[LocallyOfFiniteType]`. UniversallyClosed via `UniversallyClosed.of_valuativeCriterion` (needs
`[QuasiCompact toSpecZ]` + `ValuativeCriterion.Existence toSpecZ`). The Existence criterion is the
genuine Nitsure §1 DVR-filler (choose minimal minor J, build g-map, factor through R ⊂ K). Deep fresh
target — build the reduction + the finite-type/QC instances, then the valuative-criterion existence as
far as it goes; precise handoff if blocked.
