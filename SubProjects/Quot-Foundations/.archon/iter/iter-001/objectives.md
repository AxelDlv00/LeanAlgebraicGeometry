# Iter 001 — Objectives detail (queued for iter-002+)

No prover objectives executed this iter (mechanical gate — see plan.md). The following is the
queued ramp for the next planner, in dependency order.

## Iter-002 gating step (do first)

- Mandatory blueprint-review re-confirms the three rewritten chapters
  (`Cohomology_FlatBaseChange`, `Picard_FlatteningStratification`, `Picard_QuotScheme`) now clear
  the HARD GATE (`complete: true` + `correct: true`, no must-fix). The TODO-pin nodes will still
  read `unmatched_lean` (intentional — they are scaffold targets, not gate failures). If a chapter
  still fails, dispatch a scoped blueprint-writer before the corresponding scaffold.

## Lane GF (most tractable — start here)

File `AlgebraicJacobian/Picard/FlatteningStratification.lean`.
1. Scaffold `genericFlatnessAlgebraic` as a real decl using the `% INTENDED LEAN SIGNATURE:` block
   in `chapters/Picard_FlatteningStratification.tex` (A noeth domain, B finite-type A-algebra, M
   finite B-module via scalar tower → `∃ f ≠ 0, Module.Free (Localization.Away f)
   (LocalizedModule (powers f) M)`). Repin the chapter `\lean{}` from `TODO.` to the real name.
2. Re-sign `genericFlatness`: add `[F.IsQuasicoherent] [F.IsFiniteType]` (currently false as
   stated). Pure signature edit; body stays `sorry`.
3. Attempt the algebraic core Mathlib-first: finite A-module case is a thin wrapper over
   `Module.FinitePresentation.exists_free_localizedModule_powers` + generic-fibre-over-Frac(A)-is-
   free. The finite-type→finite reduction (polynomial-ring residue) is the genuine gap →
   `[prover-mode: mathlib-build]`, one ingredient per iter. Reference: Nitsure §4 (blueprint).

## Lane FBC (route-pivoted; attempt after scaffold)

File `AlgebraicJacobian/Cohomology/FlatBaseChange.lean`.
1. Scaffold the two helpers from the chapter's intended signatures (keep them or repin from
   `TODO.`): `base_change_map_affine_local` (locality reduction; `[IsAffineHom f]`,
   `[F.IsQuasicoherent]`) and `pushforward_base_change_mate_cancelBaseChange` (section-level value
   of `Γ(α)` = `cancelBaseChange⁻¹`).
2. Attempt `affineBaseChange_pushforward_iso` via the direct-on-sections route (proved tilde
   dictionaries `pushforward_spec_tilde_iso` / `pullback_spec_tilde_iso` → cancelBaseChange).
   Mind the orientation `Γ(α) = cancelBaseChange⁻¹` (FBC writer note).
3. `flatBaseChange_pushforward_isIso`: needs the H⁰-as-equalizer / finite-affine-cover sheaf-
   condition packaging for `SheafOfModules` (project-side build) + `Module.Flat.{ker,eqLocus}_
   lTensor_eq` / `LinearMap.tensorEqLocusEquiv`. Likely a multi-iter engine; sequence after the
   affine lemma lands.

## Lane QUOT (blocked on predicate sub-builds)

File `AlgebraicJacobian/Picard/QuotScheme.lean`. Before re-signing/defining the four stubs, build
(`[prover-mode: mathlib-build]`) the two absent-at-pin predicates:
- schematic-support closed subscheme of a coherent sheaf + `IsProper` ("proper support over S");
- rank-`r` local-freeness for `SheafOfModules` (`IsLocallyFree` upstream-only, rank-agnostic).
Then re-sign: `hilbertPolynomial`/`QuotFunctor` (+coherence on F/E), `Grassmannian` (+locally-free
+ `1 ≤ d ≤ r`, defined via `QuotFunctor`), `Grassmannian.representable` → `(Grassmannian V d).
IsRepresentable` with target universe pinned to the schemes-category hom-universe.
`thm:grassmannian_representable` PROOF stays blocked on the RelativeSpec `RepresentableBy`
strengthening (STRATEGY open question) — defer.

## blueprint-clean

Run after the scaffold/re-sign passes consume the intended-signature comments and BEFORE the
prover dispatch (purity gate). It will strip the now-redundant `% INTENDED LEAN SIGNATURE:`
scaffold comments — that is correct once they have served their purpose.
