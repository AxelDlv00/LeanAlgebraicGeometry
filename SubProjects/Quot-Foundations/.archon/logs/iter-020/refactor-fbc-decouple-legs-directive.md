# refactor directive — FBC: decouple the Seam-2 coherence from the leg-equality proofs (iter-020)

## File (only file you may touch)
`AlgebraicJacobian/Cohomology/FlatBaseChange.lean`

## Why (root cause — from `analogies/fbc-mate-legreindex.md`, a cross-domain Mathlib analysis)
The Seam-2 assembly `base_change_mate_fstar_reindex_legs` has carried a `sorry` for **6 consecutive
iters** (014–019) on the step-(iii) "mate-unwinding crux". The blocker ("leg-lock") is a *symptom*.
The **disease** is structural: the coherence object `base_change_mate_codomain_read_legs` (def at
line ~1210) is parametrized by the *equality proofs* `_hfst : g' = e.hom ≫ Spec.map inclA`,
`_hsnd : f' = e.hom ≫ Spec.map inclR'`, and the assembly `subst`s them. After `subst`, the leg
becomes a locked literal `(pullbackSpecIso …).hom ≫ Spec.map (ofHom …)` that no positional
`rw [base_change_mate_fstar_reindex_legs_unitExpand …]` can re-abstract — the pattern
`(pullbackPushforwardAdjunction (?a ≫ ?b)).unit.app ?N` will not unify against the locked `≫`
(dependent-motive wall), so the two already-proved links `_unitExpand`/`_gammaDistribute` cannot even
match into the assembly.

**Mathlib's entire pull/push pseudofunctor stack — which this file already imports as
`Scheme.Modules.*` — never parametrizes a coherence by an equality proof.** Every coherence
(`pullbackComp`, `pushforwardComp`, `pullback_assoc`, `pullbackCongr`, `pushforwardCongr`) depends
only on *free morphisms*; the composite is written *explicitly*; there is no `subst`, hence no
leg-lock. The fix is to bring this file's Seam-2 coherence into that same discipline.

## What to do (structural re-cut — you re-sign/rebuild defs and relocate the sorry; you do NOT close it)

### Step 1 — make `base_change_mate_codomain_read_legs` proof-free / explicit-composite
Re-cut the def at line ~1210 so it is a function of the **free morphisms only**, with **no** `g' f'`
binders and **no** `_hfst`/`_hsnd` equality-proof binders. Its body already constructs everything
from the explicit pieces (`e := pullbackSpecIso`, `inclA`, `inclR'`) via `Scheme.Modules.pullbackCongr`,
`pullbackComp`, `pushforwardCongr`, `pushforwardComp`, the adjunction unit, and the tilde isos —
the `intro g' f' hfst hsnd` + the `(Scheme.Modules.pullbackCongr hfst)` / `(pushforwardCongr hsnd)`
steps exist *only* to bridge the abstract legs back to the explicit composite. Restate the iso
directly at the explicit-composite legs:
- domain `((Scheme.Modules.pushforward (e.hom ≫ Spec.map inclR')).obj
    ((Scheme.Modules.pullback (e.hom ≫ Spec.map inclA)).obj (tilde M)))` read by `moduleSpecΓFunctor`,
- codomain unchanged (`restrictScalars inclR' ∘ extendScalars inclA` of `M`).
Drop the `pullbackCongr hfst` / `pushforwardCongr hsnd` bridging steps (they become identities once
the legs ARE the explicit composite). Keep the rest of the construction
(`pullbackComp e.hom (Spec.map inclA)`, the unit iso on `W₀`, `pushforwardComp e.hom (Spec.map inclR')`,
`pullback_spec_tilde_iso`, `pushforward_spec_tilde_iso`). The result is a `sorry`-free def of the same
iso, now matchable. **Keep the name `base_change_mate_codomain_read_legs`** (it is `\lean`-pinned).
If the new shape makes the "_legs" suffix a misnomer, keep the name anyway — renaming a pinned decl is
out of scope.

### Step 2 — restate `base_change_mate_fstar_reindex_legs` (line ~1333) and
`base_change_mate_fstar_reindex` (line ~1435) at the explicit composite
Re-sign `base_change_mate_fstar_reindex_legs` to drop the `g' f' hfst hsnd` binders and the
`subst hfst; subst hsnd` opening, stating the identity directly at the explicit composite legs
`a := e.hom`, `b := Spec.map inclA` (and the `f'` side `e.hom ≫ Spec.map inclR'`). The goal's unit is
then literally `(pullbackPushforwardAdjunction (e.hom ≫ Spec.map inclA)).unit.app …`, against which
`base_change_mate_fstar_reindex_legs_unitExpand e.hom (Spec.map inclA) …` and `_gammaDistribute`
**unify syntactically with no `subst`**. Apply step (ii) (the `gammaMap_pushforwardComp_*` /
`gammaMap_pushforwardCongr_hom` Γ-collapse lemmas) and steps (i)+(iii-1,2) as far as they go
mechanically, then leave a **single `sorry`** at the residual telescoping cancellation (the old
`_eCancel`/`_affineUnit`/`_innerMatch` content) with a one-line comment:
`-- iter-020 refactor: legs now explicit; residual = conjugate-lift telescoping (see analogies/fbc-mate-legreindex.md)`.
Adjust `base_change_mate_fstar_reindex` so it still `exact`s/derives from the re-cut `_legs` version
(it instantiated at `pullback.fst`/`pullback.snd` before — those ARE `e.hom ≫ Spec.map inclA` etc. up
to the cone-leg identities, so the concrete version should now follow by the explicit-composite
identities the file already has, or by a thin `rw`; if a bridging step is needed leave it as a clearly
marked `sorry` too, but prefer to close it from the explicit-composite identities).

### Step 3 — do NOT touch anything else
Leave `base_change_mate_gstar_transpose` (Seam 3), `affineBaseChange_pushforward_iso`,
`flatBaseChange_pushforward_isIso`, and every other decl untouched. Do not delete `_unitExpand` /
`_gammaDistribute` (they are the matchers the re-cut enables). Do not touch the three planned-but-
absent atomic lemmas `_eCancel/_affineUnit/_innerMatch` (they were never created; their content folds
into the single residual sorry).

## Hard constraints
- **You re-sign/rebuild definitions and RELOCATE the `sorry`; you never close a proof.** The deliverable
  is a GREEN `lake build AlgebraicJacobian.Cohomology.FlatBaseChange` with the assembly `sorry` now
  sitting on a goal where `_unitExpand`/`_gammaDistribute` provably *match* (verify they elaborate
  against the new goal even if you leave the final cancellation as `sorry`).
- Keep all `\lean`-pinned names verbatim: `base_change_mate_codomain_read_legs`,
  `base_change_mate_fstar_reindex_legs`, `base_change_mate_fstar_reindex`.
- `archon-protected.yaml` is empty — no protected signatures here, re-signs are permitted.
- Verify with `lake build`, NOT `lake env lean <file>` (single-file mode emits spurious
  instance-diamond errors — see `.archon/` memory `lake-build-vs-env-lean-spurious-errors`).
- If a re-cut step genuinely cannot be made to typecheck this session, STOP at the last green state,
  leave the original decl in place with a `-- REFACTOR-BLOCKED:` note describing exactly where the
  explicit-composite restatement failed to elaborate, and report it — do not leave the file red.

## Report
In `task_results/`, record: which decls were re-signed, the exact new signatures, where the single
residual `sorry` now sits, and a confirmation that `_unitExpand`/`_gammaDistribute` unify against the
new assembly goal (so iter-021's prover can run the conjugate-lift telescoping).
