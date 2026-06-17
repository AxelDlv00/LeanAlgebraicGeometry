# Session 226 — review of iter-226

## Metadata

- **Iteration:** 226. **Mode:** one prover, `mathlib-build` (opus).
- **Project sorry count:** 80 → **80** (unchanged — the new declaration is sorry-free infra; the 80→79 mover `exists_tensorObj_inverse` remains open).
- **File-local sorry (`Picard/TensorObjSubstrate.lean`):** 3 → **3** (L641 vestigial d.2; L2027 `exists_tensorObj_inverse`; L2073 `addCommGroup_via_tensorObj`).
- **Target attempted:** the d.2-free descent re-route for `exists_tensorObj_inverse` — specifically its cheapest bridge, the "locally-iso ⇒ iso" B-connector.
- **Build:** GREEN (0 errors, re-verified first-hand). Blueprint-doctor: CLEAN (no orphan chapters, no broken refs).

## Target 1 — `isIso_of_isIso_restrict` (B-connector) — SOLVED, axiom-clean

**Statement** (`AlgebraicGeometry.Scheme.Modules`, L1943): for `φ : M ⟶ N` in `X.Modules`, a
choice function `U : X → X.Opens` with `∀ x, x ∈ U x`, and
`∀ x, IsIso ((Scheme.Modules.restrictFunctor (U x).ι).map φ)`, then `IsIso φ`. This is exactly the
shape `LineBundle.IsLocallyTrivial` supplies via choice, so the descent assembly can feed it directly.

**Verified first-hand this review:** `lean_verify` = `{propext, Classical.choice, Quot.sound}` (no
`sorryAx`); file compiles with 0 errors. The proof body is a genuine ~35-line stalkwise argument, not
a stub.

**Approach (worked on the first serious try):**
1. Reduce `IsIso φ` to: every stalk map of the underlying `Ab`-sheaf morphism
   `(toPresheaf X).map φ` is iso.
2. Per point `x`: pick a preimage `x'` of `x` under the open immersion `(U x).ι` via
   `Scheme.Hom.mem_opensRange.mp` + `Scheme.Opens.opensRange_ι`. The restriction
   `(restrictFunctor (U x).ι).map φ` is iso (hyp); the triple-composite functor
   `restrictFunctor ⋙ toPresheaf ⋙ stalkFunctor Ab.{u} x'` sends it to an iso; transport across
   `Scheme.Modules.restrictStalkNatIso (U x).ι x'` (restriction commutes with stalks) via
   `CategoryTheory.NatIso.isIso_map_iff` to land the stalk at `(U x).ι x' = x`.
3. Package `M.presheaf` / `N.presheaf` as `TopCat.Sheaf Ab.{u} X` (sheaf condition = `M.isSheaf`),
   apply `TopCat.Presheaf.isIso_of_stalkFunctor_map_iso`, reflect back to `X.Modules` through
   `Scheme.Modules.toPresheaf` (`ReflectsIsomorphisms`) with `CategoryTheory.isIso_iff_of_reflects_iso`.

**Errors hit and fixed during the attempt** (from `attempts_raw.jsonl`):
- `Unknown constant AlgebraicGeometry.IsOpenImmersion.mem_opensRange.mp` → the lemma lives in the
  `Scheme.Hom` namespace; corrected to `AlgebraicGeometry.Scheme.Hom.mem_opensRange.mp`.
- `failed to synthesize instance IsIso ((restrictFunctor ⋙ toPresheaf ⋙ stalkFunctor Ab x').map φ)`
  → `Functor.map_isIso` is not an instance through a triple composite; closed with
  `dsimp only [Functor.comp_map]; exact Functor.map_isIso _ _`.
- (Implicit) `Ab` must carry the explicit universe `Ab.{u}` everywhere or `stalkFunctor` lands at
  universe 0 and mismatches `toPresheaf X`'s `TopCat.Presheaf Ab.{u} X`.

**No stalk-⊗ ("d.2") is invoked** — this is a single-morphism statement, never the tensor stalk. The
landed lemma is the empirical first datapoint that the analogist's "route is d.2-free" verdict (ts226descent,
verdict D) survives contact with Lean.

## Target 2 — `exists_tensorObj_inverse` — BLOCKED (sorry retained, comment refreshed)

The 80→79 mover was NOT attempted as a code edit. Per the plan directive ("do NOT pin a sorry into a
NEW decl"; iter-214 d.1 anti-pattern), the prover left the existing sorry in place and refreshed its
explanatory comment to describe the d.2-free descent plan and the now-landed B-connector. The comment is
accurate (`Linv := Scheme.Modules.dual L` is nameable since iter-225; the sheafify-the-presheaf-eval
shortcut is correctly flagged as a DEAD END that re-hits the `M ◁ η` whiskering = d.2).

**Two bridges remain before this closes:**
- **(A) SheafOfModules morphism descent** (~30–60 LOC, the prover's estimate): glue the canonical local
  trivialising isos `(L ⊗ dual L)|_{Uᵢ} ≅ 𝒪_{Uᵢ}` (pattern of `tensorObj_isLocallyTrivial`, L1912) —
  agreeing on overlaps (bounded cocycle check, **NOT** d.2) — into a global
  `tensorObj L (dual L) ⟶ 𝒪_X` via `CategoryTheory.Presheaf.IsSheaf.hom` / `sheafHomSectionsEquiv`
  (`Sites/SheafHom.lean:207,241`) + `PresheafOfModules.homMk` (`Presheaf.lean:200`). Then
  `isIso_of_isIso_restrict` upgrades the glued morphism to a global iso.
- **(C) `dual_isLocallyTrivial`** (`IsLocallyTrivial L → IsLocallyTrivial (dual L)`): crux is
  `(dual M).restrict f ≅ dual (M.restrict f)` for an open immersion `f` — the dual analogue of the
  CLOSED `tensorObj_restrict_iso` (L1822). The prover itself describes this as a **"major mirror build"**:
  the hard presheaf step needs `restrictScalars` along the open-immersion ring iso to commute with the
  bespoke presheaf `dual` (= `internalHom(-, R)`, built over iters 219–224), carried across via
  `ModuleCat.restrictScalarsEquivalenceOfRingEquiv`. Plus (C2) `dual (𝒪_U) ≅ 𝒪_U` at the sheaf level.

## Key findings / patterns

- The new reusable proof pattern (locally-iso ⇒ global iso via the stalkwise criterion) is recorded in
  `PROJECT_STATUS.md` → Knowledge Base → Proof patterns, with the three API gotchas.
- The route's remaining cost is **front-loaded into bridge C**, not bridge A. The plan's STRATEGY
  estimate (~3–5 iters / ~150–250 LOC for the merged dual block) is now testable; C alone is a
  multi-iter mirror of an already-hard closed lemma.

## Blueprint markers updated (manual)

- None. The new lemma `isIso_of_isIso_restrict` is not Mathlib-backed (no `\mathlibok`), was not
  renamed from any planned name (no `\lean{...}` correction), and is not yet `\lean{}`-pinned in any
  chapter — adding a named blueprint block is a plan-agent action (deferred by the iter-226 planner;
  see recommendations). No stale `\notready` to strip on this file's coverage.

## `\leanok` sync note

`sync_leanok-state.json` reports `iter: 226`, sha `591de177`, **+1 / −0**, `chapters_touched:
[AbelianVarietyRigidity.tex]`. The single `\leanok` addition is in `AbelianVarietyRigidity.tex`, a
chapter unrelated to this iter's prover work on `TensorObjSubstrate.lean` — it is the deterministic
script reconciling a previously-landed declaration, not laundering of this iter's work. No action.

## Notes (LOW)

- Pre-existing `opaque`-pattern warning at L1864 of `TensorObjSubstrate.lean` (flagged by `lean_verify`'s
  source scan); not introduced this iter.

## Recommendations

See `recommendations.md`. Headline: attempt bridge A first (cheaper, bounded), and budget bridge C as a
multi-iter mirror build; watch for the analogist-named reversal signal (A or C silently re-requiring a
stalk/colimit-⊗ statement).
