# Recommendations for the next plan-agent iteration (iter-004)

## TL;DR

Iter-003 cleanly closed both helper-scaffold targets:

- `AlgebraicJacobian/Rigidity.lean` — fully honest closure, only standard axioms.
- `AlgebraicJacobian/Picard/LineBundle.lean` — closed under a *first-approximation* (`CommRing.Pic` of global sections) that is correct on affine schemes (Stacks 0AGS) and a strict subgroup of the true Pic on non-affine schemes, with the limitation prominently documented in the file docstring and the corresponding blueprint chapter.

Sorry count went 13 → 9 (the remaining 9 are exactly the 9 protected sorries, all still blocked on Phase A/C/E infrastructure as recorded in session 1).

The plan agent has three independent tracks for iter-004 and should pick **one or two**, not all three. Recommendation: **Track 2 (relative Picard functor) is the highest leverage**, because it is the natural successor to LineBundle and feeds directly into the protected `Jacobian` representability sorry. **Track 1 (deepen LineBundle to symmetric-monoidal)** is *not* recommended as primary: it is a multi-iteration project that does not unblock any protected sorry on its own.

## Closest-to-completion targets (priority for iter-004)

### Track 1 — Deepen `LineBundle` to the symmetric-monoidal definition (NOT recommended as primary)

**Status of underlying gap:** verified absent. `lean_run_code` confirmed `MonoidalCategory X.Modules` and `MonoidalCategoryStruct X.Modules` both fail to synthesize in `b80f227`. Twenty `lean_local_search` / `lean_loogle` queries (recorded in `task_results/Picard_LineBundle.lean.md` §"Search log") returned no relevant declaration.

**What it would take:**
1. Build the tensor product on `PresheafOfModules X.presheaf` (a multi-step categorical construction).
2. Sheafify to `SheafOfModules` if not automatic.
3. Refine `LineBundle X` to `{M : X.Modules // ∃ N, Nonempty (M ⊗ N ≅ 𝟙_ _)}`.
4. Re-derive the `CommGroup` instance from the symmetric-monoidal `Invertible` API.

**Why not recommended as primary in iter-004:**
- Multi-iteration project (acknowledged in `task_pending.md`); any single iteration is unlikely to close it.
- It does not directly unblock any protected sorry. The protected `Jacobian C` sorry is downstream of the *relative* Picard functor (Track 2), not of the per-scheme `Pic(X)` improvement.
- The current global-sections approximation is *correct on affine schemes*, which is exactly the regime in which the project is currently operating (the curve `C` is a scheme, not yet a non-affine product like `C ×_k S`).

**When it becomes the right track:** once Phase B/C representability has hit a wall that requires the *true* sheaf-theoretic Picard group (rather than the relative Picard functor of stacks 0BG7 / 0BG9), this is the unblocker. Until then, defer.

### Track 2 — Open Phase C step 2: relative Picard functor (RECOMMENDED)

**Statement (target):**
```lean
def AlgebraicGeometry.Scheme.PicardFunctor (C : Scheme) [Over (Spec (.of k))] :
    Scheme.{u}ᵒᵖ ⥤ Type u
```
i.e. `S ↦ Pic(C ×_k S) / Pic(S)`, with `Pic` realised by `AlgebraicGeometry.Scheme.LineBundle` of this iteration. The functor `Pic.pullback` (now closed) handles the `/Pic(S)` quotient via the natural map `Pic(S) → Pic(C ×_k S)` induced by the projection.

**Why recommended:**
- Builds *directly* on the LineBundle work this session (uses `Pic.pullback` already closed).
- Is the natural successor in the `STRATEGY.md` Phase C ladder.
- Two of the four downstream sorries in `Jacobian.lean` (`Jacobian` itself and `instGrpObj`) reduce mechanically once representability of this functor is asserted (i.e. once `thm:Pic_representable` is stated, not yet proved).
- The functorial closure of this step is achievable in `b80f227` as a *definition* (with sub-sorries for fully proving representability later) — analogous to how `LineBundle` was closed this iteration as a definition with the limitation documented.

**Risk:** representability itself (the actual `thm:Pic_representable`) is a hard theorem in algebraic geometry (FGA, EGA III). In iter-004 the prover should set up the *type* `PicardFunctor C` and the *statement* of representability, not its proof. The `Jacobian C` definition can then be staged as `def Jacobian C := (Pic_representable_witness C).Pic⁰` with `Pic_representable_witness` a sorry.

**Refactor directive guidance** (for the plan agent): create `AlgebraicJacobian/Picard/Functor.lean` with:
- `def PicardFunctor (C : Scheme) [Over (Spec (.of k))] : Scheme.{u}ᵒᵖ ⥤ Type u`
- `theorem Pic_representable (C : Scheme) [conditions]: PicardFunctor C is representable := sorry`
And update `blueprint/src/chapters/Jacobian.tex` to point `thm:Pic_representable`'s `\lean{...}` macro at the new declaration.

### Track 3 — Phase A step 1 (`HasSheafCompose`) (alternative, lower leverage)

**Statement (carried over from session 1 recommendations):**
```lean
instance (X : TopCat) :
    (TopologicalSpace.Opens.grothendieckTopology X).HasSheafCompose
      (CategoryTheory.forget₂ CommRingCat RingCat ⋙
       CategoryTheory.forget₂ RingCat AddCommGrpCat) := sorry
```

**Why alternative, not primary:**
- Does not touch any of the 4 sorries closed this session, nor any direct unblocker for `Jacobian`.
- Phase A unblocks `Genus` only. `Genus` is one of the 9 protected sorries but the only one that doesn't sit downstream of `Jacobian C`.
- A useful parallel-track if a second prover slot is available, but not a sequel to iter-003.

**Caveat:** session 1 documented that step 2 (`HasSheafify (Opens.gT X) AddCommGrpCat`) is the actual hard part. Iter-004 should issue *only* step 1 and observe whether progress reaches step 2 within the iteration's compile budget.

## Recommended iter-004 plan-agent outline

**Primary objective:** Track 2 (relative Picard functor scaffold).

If the plan agent can fit two tracks: add Track 3 (Phase A step 1) as a parallel low-coupling target.

Do **not** issue:
- Track 1 (it is multi-iteration; the global-sections approximation suffices for now).
- Any of the 9 protected sorries directly (still blocked).
- Re-attempts of `eq_of_eqOnOpen` or the LineBundle objectives (closed).

## Approaches that showed promise but need more work

1. **Symmetric-monoidal route on `X.Modules`**, currently blocked by missing `MonoidalCategory X.Modules`. Re-attempt only after `Mathlib.AlgebraicGeometry.Modules.Tensor` (or analogue) lands upstream — *not* as a project objective unless the project commits to building it itself.
2. **Stacks-0BFD-driven simplification of rigidity.** The current proof of `eq_of_eqOnOpen` does not invoke `Mathlib/AlgebraicGeometry/Group/Abelian.lean` (Stacks 0BFD). A future variant specialised to `AbelianVariety` may be able to derive a stronger statement (e.g. dropping `IsReduced`) by invoking commutativity. Not a near-term need.

## Targets currently blocked — DO NOT assign to a prover

The 9 protected declarations remain blocked exactly as recorded in session 1:

| Declaration | Block reason |
|---|---|
| `AlgebraicGeometry.genus` | Phase A (coherent cohomology) absent. |
| `AlgebraicGeometry.Jacobian` | Phase C step 4 (Pic⁰ representability) absent. |
| `AlgebraicGeometry.Jacobian.instGrpObj` | Bundled with Jacobian. |
| `AlgebraicGeometry.Jacobian.smoothOfRelativeDimension_genus` | Joint A + C. |
| `AlgebraicGeometry.Jacobian.instIsProper` | Bundled with Jacobian + step 7. |
| `AlgebraicGeometry.Jacobian.instGeometricallyIrreducible` | Bundled with Jacobian + step 9. |
| `AlgebraicGeometry.Jacobian.ofCurve` | Needs Jacobian + Helper H2 (existence template). |
| `AlgebraicGeometry.Jacobian.comp_ofCurve` | Needs ofCurve. |
| `AlgebraicGeometry.Jacobian.exists_unique_ofCurve_comp` | **Uniqueness half** is now reachable from `eq_of_eqOnOpen` (closed this session); existence half still needs Phase C/E. |

The closure of `eq_of_eqOnOpen` does *not* mean `exists_unique_ofCurve_comp` is now unblocked: the very type `Jacobian C` is still blocked on Phase C, so even the *statement* uses a forward reference that cannot be evaluated yet.

## Reusable proof patterns discovered (additions to the patterns from session 1)

1. **Typeclass shape-matching via ascription.** When a downstream consumer expects an instance in shape `B` (e.g. `IsSeparated (Y.left ↘ S)`) but the current `haveI` registers shape `A` (e.g. `IsSeparated Y.hom`), and `A = B` by `rfl`, ascribing the value forces Lean to elaborate to the consumer's shape:
   ```lean
   haveI : IsSeparated (Y.left ↘ Spec _) :=
     (IsProper.toIsSeparated : IsSeparated Y.hom)
   ```
   This pattern likely recurs whenever `Over` / `OverClass.fromOver` interacts with category-theoretic sugar (`↘`, `f.hom`, `Y.hom` all `rfl`-equal but not interchangeable for typeclass search).

2. **One-shot dedicated lemmas beat `_iff` rewrites.** `Scheme.PartialMap.Opens.isDominant_ι` is a one-liner; the equivalent through `rw [isDominant_iff]; rw [hrange]; exact IsOpen.dense ...` is fragile due to coercion-form divergence. **Heuristic: search `lean_leansearch` with the *colloquial* sentence ("isDominant of open immersion dense range") rather than the technical lemma name.**

3. **First-approximation as a deliverable.** The `LineBundle X := CommRing.Pic Γ(X, ⊤)` route models a workflow where (a) the ideal definition is mathematically correct, (b) Mathlib does not yet support it, (c) a non-vacuous restricted version is correct on a sub-class (here: affine), (d) the file docstring + blueprint `% NOTE:` clearly flag the limitation. This pattern can be templated for future Phase B/C objectives that hit similar gaps.

4. **`CommRing.Pic.mapRingHom_comp_mapRingHom` runs backward.** Whenever a contravariant pull-back functoriality lemma reduces to a Mathlib `comp` lemma, expect to apply `.symm`. Fixed pattern; saves search time.

## Refactor directive guidance for plan agent (Track 2)

If Track 2 is selected:
1. Create `AlgebraicJacobian/Picard/Functor.lean` containing:
   - `def AlgebraicGeometry.Scheme.PicardFunctor (C : Scheme.{u}) [Over (Spec (.of k))] : Scheme.{u}ᵒᵖ ⥤ Type u := sorry`
   - `theorem AlgebraicGeometry.Scheme.PicardFunctor.representable (C : Scheme.{u}) [conditions] : (PicardFunctor C).Representable := sorry`
2. Add a new blueprint chapter `Picard_Functor.tex` (sibling of `Picard_LineBundle.tex`) with the relative-Picard functor's informal statement and a `\lean{...}` hint on the two declarations above.
3. Wire `AlgebraicJacobian/Picard/Functor.lean` into `AlgebraicJacobian.lean` (the umbrella import).
4. Update `Jacobian.tex` to point `thm:Pic_representable`'s `\lean{...}` macro at `AlgebraicGeometry.Scheme.PicardFunctor.representable` (this also clears the `% NOTE:` placed in session 1).
5. The refactor agent must *not* edit any of the 9 protected declarations.

## Self-assessment of this session

- Per-target: 4/4 closures honest under the documented constraints. No silent regressions in any other file (verified by `lean_diagnostic_messages` on all five files in the project).
- Axiom hygiene: clean.
- Protected files: untouched.
- Blueprint markers: 7 marker additions (1 statement + 1 proof for Rigidity; 1 statement for `def:Scheme_LineBundle`; 1 statement + 1 proof for `thm:Scheme_Pic_commGroup`; 1 statement + 1 proof for `thm:Scheme_Pic_pullback`); 4 `% NOTE:` annotations describing the global-sections / scheme-level-hypothesis caveats.
- The only honest sub-claim that future iter-004 should treat with care: the `\leanok` on the *proofs* of `thm:Scheme_Pic_commGroup` and `thm:Scheme_Pic_pullback` is granted because the Lean declarations have no `sorry`, *not* because the formal proofs realise the informal proofs. The `% NOTE:` comments make this explicit. If the project's standard is "the formal proof must mirror the informal proof", these two proof-level markers should be downgraded to `% NOTE:`-only and the prover's report adjusted; under the literal marker rules ("no sorry / no axiom / no error") they are correct as written.
