# Lean ↔ Blueprint Check Report

## Slug
linebundle-iter109

## Iteration
109

## Files audited
- Lean: `AlgebraicJacobian/Picard/LineBundle.lean`
- Blueprint: `blueprint/src/chapters/Picard_LineBundle.tex`

## Per-declaration

### `\lean{AlgebraicGeometry.Scheme.LineBundle}` (chapter: `\def:Scheme_LineBundle`)
- **Lean target exists**: yes (`LineBundle.lean:52`).
- **Signature matches**: yes. The blueprint's "Status note (Phase C1, post-refactor)" paragraph (L17–22) explicitly endorses the skeleton-units idiom
  `LineBundle X := (Skeleton X.Modules)ˣ` as the formalization of "invertible quasi-coherent O_X-module", mirroring `CommRing.Pic R = Shrink (Skeleton (SemimoduleCat R))ˣ`.
- **Proof follows sketch**: N/A (it is a definition; the blueprint and the Lean agree on the body).
- **notes**: Universe matches — the blueprint explicitly notes no `Shrink` wrapper is needed because `X.Modules` lives in `Type (u+1)`.

### `\lean{AlgebraicGeometry.Scheme.instCommGroupLineBundle}` (chapter: `\thm:Scheme_Pic_commGroup`)
- **Lean target exists**: yes (`LineBundle.lean:64`).
- **Signature matches**: yes. Both blueprint and Lean state `CommGroup (LineBundle X)`.
- **Proof follows sketch**: yes. Blueprint proof (L46–58) describes the chain `BraidedCategory (X.Modules) ⇒ CommMonoid (Skeleton X.Modules) ⇒ CommGroup (Skeleton X.Modules)ˣ` via `Skeleton.instCommMonoid` + `instCommGroupUnits`; the Lean body is exactly `inferInstanceAs (CommGroup (Skeleton X.Modules)ˣ)` which resolves through that same chain.
- **notes**: Load-bearing on `instIsMonoidal_W` — already disclosed in the chapter and the docstring.

### `\lean{AlgebraicGeometry.Scheme.Pic.pullback}` (chapter: `\thm:Scheme_Pic_pullback`)
- **Lean target exists**: yes (`LineBundle.lean:108`).
- **Signature matches**: yes. Both produce `Pic Y →* Pic X` from `f : X ⟶ Y`.
- **Proof follows sketch**: **partial** — see explanation below.
  - Blueprint sketch (L77–81): "The eventual Lean definition is `f^* = Units.map (Skeleton.monoidHom (Scheme.Modules.pullback f))`", i.e. the units functor applied to the monoid homomorphism on skeletons induced by a monoidal functor.
  - Lean body (L108–127): the iter-109 prover did **not** wait for `Skeleton.monoidHom`. Instead it hand-builds the underlying `MonoidHom (Skeleton Y.Modules) (Skeleton X.Modules)` by lifting `(Scheme.Modules.pullback f).mapSkeleton.obj` to a structured monoid hom via explicit `map_one'` and `map_mul'` proofs, where:
    - `map_one'` routes through the new helper `SheafOfModules.pullback_oneIso` (unit-preservation iso) and `congr_toSkeleton_of_iso`,
    - `map_mul'` routes through `SheafOfModules.pullback_tensorObj` and `fromSkeletonToSkeletonIso`,
    - finally `Units.map` lifts the resulting `MonoidHom` to `Pic Y →* Pic X`.
  - **Mathematical content matches.** This is just an unbundled construction of `Skeleton.monoidHom` from the iso data that the (missing) `Functor.Monoidal` instance would otherwise package. Both routes consume exactly the same two named-deferred Mathlib gaps (the `μIso` and `εIso` of `Functor.Monoidal (Scheme.Modules.pullback f)`).
  - The blueprint sketch should be updated to acknowledge the chosen route (split the named-deferral into a tensor-iso oracle + a unit-iso oracle, with `f^*` then assembled by `Units.map` on the hand-built `MonoidHom`).
- **notes**: The "remain `sorry`" clause at the end of the proof block (L81) is now stale — the body of `Pic.pullback` itself is closed; only the two oracle isos carry `sorry`.

### `\lean{AlgebraicGeometry.Scheme.SheafOfModules.pullback_tensorObj}` (chapter: `\thm:SheafOfModules_pullback_tensorObj`)
- **Lean target exists**: yes (`LineBundle.lean:82`).
- **Signature matches**: yes. `(pullback f).obj (M ⊗ N) ≅ (pullback f).obj M ⊗ (pullback f).obj N`.
- **Proof follows sketch**: N/A. Body is `sorry` — explicitly named-deferred Mathlib gap per analogist option (c). Both the blueprint (L98–102) and the Lean docstring (L71–81) disclose this status correctly.
- **notes**: Proof sketch in the blueprint (tensor-hom adjunction + Stacks 01AC + Hartshorne II.5) is adequate to guide a future formalization, but is not currently being formalized — the named-deferral is in effect.

## Red flags

### Placeholder / suspect bodies

- `SheafOfModules.pullback_tensorObj` at L82–86: `sorry` body. **Authorized** — named-deferred Mathlib gap, transparently disclosed in both the chapter prose (`\thm:SheafOfModules_pullback_tensorObj`) and the Lean docstring (L71–81). Not a violation; reported here only for completeness.
- `SheafOfModules.pullback_oneIso` at L96–98: `sorry` body. **Companion oracle, partially-authorized**: the Lean docstring (L88–95) explicitly frames this as the unit-preservation half of the same Mathlib gap as `pullback_tensorObj`, but the **blueprint chapter does not yet record this companion oracle as a separate `\thm:...` block.** This is a documentation gap (covered under "Blueprint adequacy" below, not as a Lean-side red flag).

No other suspect bodies. `Pic.pullback`, `Pic.pullback_id`, `Pic.pullback_comp` all carry genuine proofs (verified by reading the bodies at L108–127, L131–142, L147–162).

### Excuse-comments

- `LineBundle.lean:32–37` (module docstring "Pull-back gap"): says
  > "`Pic.pullback` body is `sorry`. It awaits closure of `SheafOfModules.pullback_tensorObj` below — the named-deferred Mathlib gap …"
  This is **stale post iter-109** in two distinct ways: (i) the body of `Pic.pullback` is no longer `sorry` (it now type-checks via the two iso oracles), and (ii) the gap is now two oracles (`pullback_tensorObj` + `pullback_oneIso`), not one. Not actively misleading about correctness, but the wording will confuse a reader.

### Axioms / Classical.choice on non-trivial claims
- None observed. No `axiom` declarations; no spurious `Classical.choice _` patterns.

## Unreferenced declarations (informational)

- `AlgebraicGeometry.Scheme.Pic` (`LineBundle.lean:69`) — `abbrev` for `LineBundle`. **Acceptable**: it is a transparent abbreviation introduced by the same chapter; downstream files reference it by name.
- `AlgebraicGeometry.Scheme.Pic.pullback_id` (`LineBundle.lean:131`) — substantive functoriality lemma. **Should be referenced** by the blueprint (see below).
- `AlgebraicGeometry.Scheme.Pic.pullback_comp` (`LineBundle.lean:147`) — substantive functoriality lemma. **Should be referenced** by the blueprint (see below).
- `AlgebraicGeometry.Scheme.SheafOfModules.pullback_oneIso` (`LineBundle.lean:96`) — companion oracle to `pullback_tensorObj`. **Should be referenced** by the blueprint (see below).

## Blueprint adequacy for this file

- **Coverage**: 4 / 7 substantive declarations (`LineBundle`, `instCommGroupLineBundle`, `Pic.pullback`, `pullback_tensorObj`) carry a `\lean{...}` block. 1 abbrev (`Pic`) is helper-acceptable. **3 substantive declarations** lack a `\lean{...}` block:
  - `SheafOfModules.pullback_oneIso` — new in iter-109 as the unit half of the (split) Mathlib gap.
  - `Pic.pullback_id` — functoriality lemma; mentioned in the prose of `\thm:Scheme_Pic_pullback` ("Pull-back is contravariantly functorial: $(\mathrm{id}_X)^* = \mathrm{id}_{\Pic(X)}$ …") but not pinned by a `\lean{...}` hint.
  - `Pic.pullback_comp` — same situation: prose-only mention, no `\lean{...}` pin.
- **Proof-sketch depth**: adequate overall, but the `\thm:Scheme_Pic_pullback` proof sketch (L74–82) describes a route (`Units.map ∘ Skeleton.monoidHom`) that the iter-109 prover did not literally take. The chosen hand-construction (route through two iso oracles + `Units.map` on a manually-bundled `MonoidHom`) is mathematically equivalent but is not previewed by the blueprint; a prover reading only the blueprint would attempt to invoke `Skeleton.monoidHom` and fail because the missing `Functor.Monoidal` instance has not been hand-supplied either. The blueprint should be expanded to describe the chosen route.
- **Hint precision**: precise for the four `\lean{...}` blocks that exist; the gap is the three missing blocks listed above.
- **Generality**: matches need.
- **Stale prose to refresh**:
  - L62 NOTE: "the Lean bodies of `Pic.pullback`, `Pic.pullback_id`, and `Pic.pullback_comp` are currently `sorry`" — **stale**, all three now have closed proof bodies (gated only on the two iso oracles). (Known issue per directive.)
  - L81 (end of `\thm:Scheme_Pic_pullback` proof block): "the Lean bodies of `Pic.pullback`, `Pic.pullback_id`, and `Pic.pullback_comp` remain `sorry`" — same stale assertion in body prose. (Known issue per directive.)
- **Recommended chapter-side actions** (for a blueprint-writer follow-up):
  1. Add a new theorem block `\thm:SheafOfModules_pullback_oneIso` (statement-only, named-deferred Mathlib gap, sibling to `\thm:SheafOfModules_pullback_tensorObj`) with `\lean{AlgebraicGeometry.Scheme.SheafOfModules.pullback_oneIso}`. The two together represent the `μIso` and `εIso` of `Functor.Monoidal (Scheme.Modules.pullback f)` and `lean_verify`'s axiom chain on `Pic.pullback` surfaces both — keeping only one of them recorded would mismatch the chain.
  2. Add `\lean{...}` hint blocks (or short theorem blocks) for `Pic.pullback_id` and `Pic.pullback_comp` — both are substantive lemmas whose statements are already implied by the prose.
  3. Refresh the L62 NOTE and the L81 closing sentence: the three `Pic.pullback*` bodies are no longer `sorry`; only `SheafOfModules.pullback_tensorObj` and `SheafOfModules.pullback_oneIso` are. The named-deferral is now two-oracle, not one.
  4. Update the `\uses{...}` of the `\thm:Scheme_Pic_pullback` proof block: it should depend on both `\thm:SheafOfModules_pullback_tensorObj` and the new `\thm:SheafOfModules_pullback_oneIso`.
  5. Refresh the L77–81 proof-sketch route to describe the iter-109 hand-construction (`Units.map` on a hand-bundled `MonoidHom` whose `map_one'`/`map_mul'` route through the two iso oracles), or alternatively note that the prover may also wait for `Skeleton.monoidHom` once a `Functor.Monoidal` instance is in hand.

## Severity summary

- **must-fix-this-iter**: none. No placeholder bodies on declarations the blueprint claims are substantive (the two `sorry`s are on declarations the blueprint *itself* records as named-deferred Mathlib gaps); no signature mismatches; no unauthorized axioms; no weakened-wrong definitions.
- **major**:
  - Missing `\lean{...}` references for `Pic.pullback_id` and `Pic.pullback_comp` (substantive functoriality lemmas; only prose-mentioned).
  - Missing `\lean{...}` reference (and probably a sibling theorem block) for the new `SheafOfModules.pullback_oneIso` — the second half of the now-split named-deferred Mathlib gap.
  - Stale "remain `sorry`" prose at L62 and L81 (known per directive; relisted only for the review agent's action list).
- **minor**:
  - Stale module-docstring paragraph at `LineBundle.lean:32–37` ("`Pic.pullback` body is `sorry` … awaits closure of `SheafOfModules.pullback_tensorObj`"). The prover is allowed to edit own-file docstrings; review-agent should flag for next prover touch.
  - Proof-sketch in `\thm:Scheme_Pic_pullback` describes a route (`Skeleton.monoidHom`) different from the iter-109 hand-construction.

**On the directive's "opine" question** (should `pullback_oneIso` get its own `\thm:...` block, or is helper-only OK?): **mild preference for adding a sibling block.** Reasons: (i) the two `sorry`s together represent `μIso` + `εIso` and will collapse simultaneously under a future Mathlib `(Scheme.Modules.pullback _).Monoidal`, so symmetry of presentation matches the actual mathematical content; (ii) `lean_verify`'s axiom chain on `Pic.pullback` exposes both `sorryAx`-instances and a chapter that records only one would mislead an auditor; (iii) the `Pic.pullback` proof body cites both oracles by name, so a reader of the chapter has no place to look up the second one. Marginally helper-acceptable if the chapter prose explicitly enumerates "the named deferral is the pair (`pullback_tensorObj`, `pullback_oneIso`)", but a sibling theorem block is cleaner.

**Overall verdict**: The Lean file faithfully formalizes the chapter's intent — iter-109 closed `Pic.pullback`, `Pic.pullback_id`, `Pic.pullback_comp` via a hand-construction equivalent to the blueprint's stated route, gated on the two named-deferred iso oracles. Documentation drift (one new helper unreferenced, two functoriality lemmas without `\lean{...}` hints, stale "remain `sorry`" prose, stale module docstring) is the only finding. No must-fix-this-iter issues.
