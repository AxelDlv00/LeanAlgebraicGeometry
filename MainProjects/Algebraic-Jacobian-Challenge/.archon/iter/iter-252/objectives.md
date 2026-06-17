# Iter-252 objectives — detail & recipes

Two parallel prover lanes (M=2), both A.1.c.sub, both feeding `RelPicFunctor.addCommGroup`.
Blueprint chapter for BOTH: `blueprint/src/chapters/Picard_TensorObjSubstrate.tex` (consolidated;
`% archon:covers` lists `TensorObjSubstrate.lean`, `StalkTensor.lean`, `Vestigial.lean`,
`DualInverse.lean`). HARD GATE cleared by blueprint-reviewer br252 (PASS, 0 must-fix).
progress-critic pc252: Route 1 CHURNING (corrective = the whisker analogist consult BEFORE dispatch —
EXECUTED, `analogies/whisker252.md`); Route 2 UNCLEAR (arm Step-4 — EXECUTED, `analogies/dual252.md`);
dispatch-sanity OK for M=2.

---

## Lane TS-cmp — `Picard/TensorObjSubstrate.lean` [prove] — CRITICAL PATH

**READ `analogies/whisker252.md` IN FULL before touching `sheafifyTensorUnitIso_hom_natural`.** The
iter-251 prover's diagnosis ("whisker lemmas all fail; author a second carrier-normalisation brick")
was LIVE-disproven by whisker252: the whisker calculus DOES fire within a single-instance group; the
real blocker is an **instance-TERM split** (the brick's η-whiskers carry the `letI instMS` term while
`p ⊗ₘ q` uses the directly-synthesised term — one struct, two terms). **Do NOT author a new whisker
brick; do NOT fold to `tensorHom` (verified dead).**

### STEP A (PRIMARY) — close `sheafifyTensorUnitIso_hom_natural` (sorry ~L1954)
Apply the whisker252 recipe (all sub-steps LIVE-verified by the analogist via `lean_multi_attempt`):
1. Add at the top the verbatim `letI instMS : MonoidalCategoryStruct (PsM (Sheaf.val X.ringCatSheaf))
   := inferInstanceAs (MonoidalCategoryStruct (PsM (X.presheaf ⋙ forget₂ CommRingCat RingCat)))`
   (copy of L339 / L1071) so the `p ⊗ₘ q` whiskers and the brick's η-whiskers share ONE instance term.
2. Replace the blind `simp only [tensorHom_def]` with `erw [Category.assoc]` to bridge the cross-group
   `≫` join (plain `rw`/`simp [Category.assoc]` cannot), then `MonoidalCategory.whisker_exchange` on the
   now-adjacent middle crossings + `← MonoidalCategory.comp_whiskerRight` / `← MonoidalCategory.whiskerLeft_comp`
   to merge, threading `erw [Category.assoc]` for associativity.
3. Finish with `(PresheafOfModules.sheafificationAdjunction (R := X.ringCatSheaf) (𝟙 X.ringCatSheaf.val)).unit.naturality p`
   / `… q`, then `restrictScalarsId_map` to strip the spurious `restrictScalars (𝟙)` (same strip as D2′).
Verified lemma list in `analogies/whisker252.md`. Avoid `← tensorHom_def`, `tensorHom_comp_tensorHom`.

### STEP B — close D1′ `pullbackTensorMap_natural` (sorry ~L1983)
Once Step A closes, assemble per the iter-251 handoff: merge `a_Y.map δ ≫ S3 ≫ S4` into `a_Y.map Ψ`,
move S1 by `(sheafificationCompPullback φ).hom.naturality (tensorHom a.val b.val)`, discharge the
presheaf equation by `δ_natural` (square 2) + the two helpers (`pullbackValIso_hom_natural` CLOSED,
`sheafifyTensorUnitIso_hom_natural` from Step A). The `pullbackValIso`/`pullback φ`-vs-`pullback f`
idiom kit is in the iter-251 task result.

### STEP C — attempt D3′ `pullbackTensorMap_restrict` (armed by `analogies/d3-251.md`)
Mirror the CLOSED `pullbackObjUnitToUnit_comp` (L859), `_η`→`_δ`, at the PRESHEAF level; transport
through the 3 sheafification bridges with the iter-250 `.val`-friction kit. Re-derive the presheaf-level
conjugate-pullbackComp identity (sheaf one not reusable for δ). Read d3-251 IN FULL.

### STEP D (stretch) — D4′ only if D3′ closes (chart-chase via `isiso_of_isiso_restrict` → `IsInvertible.pullback`).

### Required cleanup (prover owns this file; lean-auditor aud251 + checker ts251):
- Fix the stale `## Status (current)` header at L44 + the sub-module bullet at L123: they say "ONE
  tracked typed-sorry" but the file now has THREE (L705, L1954, L1983). Update both to the real count/list.
- Remove the duplicate comment block at L1821–1823 (scratch leftover, superseded by L1824–1832).

**Bar:** close Step A + D1′ at minimum (now de-risked by whisker252 — the instance-unify + `erw`
join-bridge is verified to fire). Attempt D3′ with the armed kit; leave REAL compiling partial state +
a one-line handoff naming the EXACT residual if D3′ resists. D4′ is the stretch.

**Reversing signal (armed):** if Step A does NOT close even with the `letI instMS` instance-unify +
`erw` join-bridge, the friction is deeper than an instance-term split → STOP, flag for a structural
rethink of the D1′ proof shape — do NOT author a 4th carrier brick or a cosmetic retry.

**Coordination constraint:** `DualInverse.lean` imports this file. Keep `TensorObjSubstrate.lean`
COMPILABLE at every intermediate checkpoint so the parallel TS-inv lane can verify (iter-251 hazard).

**Guardrails:** do NOT touch `exists_tensorObj_inverse` (~L705, stays a sorry this iter). Do NOT revive
the general Lan build (off path).

---

## Lane TS-inv — `Picard/TensorObjSubstrate/DualInverse.lean` [prove] — INDEPENDENT parallel lane

**READ `analogies/dual252.md` IN FULL before `dual_restrict_iso` Step 4.**

### STEP A (PRIMARY) — close `homOfLocalCompat` (sorry ~L420) — FRONTIER base, all deps closed
No analogist consult needed; pure gluing labor. 2-step: (i) glue the underlying ab-sheaf morphism via
`TopCat.Presheaf.IsSheaf.hom` + `existsUnique_gluing`, converting each `f i` to a local section through
`Vestigial.overSliceSheafEquiv`; (ii) promote to `𝒪_X`-linear via `Scheme.Modules.homMk`. **Build the
`s i` naturality field (+ its `Subsingleton.elim`-on-thin-poset naturality) as a standalone lemma FIRST.**
Full recipe in the in-file `/- Planner strategy: -/` stub.

### STEP B — `dual_restrict_iso` Step-4 residual (sorry ~L254) — armed by dual252 (was UNDER-SCOPED)
The iter-251 plan ("sectionwise via `restrictScalarsRingIsoDualEquiv` alone") is INSUFFICIENT (dual252
MAJOR): `dual` is NOT sectionwise (it is a Hom over the whole down-set `Over U`, not a fiber), so the
residual `(pushforward β).obj (dual M.val) ≅ dual ((pushforward β).obj M.val)` couples TWO legs:
- **Leg (A) — slice-site Hom base-change (Beck–Chevalley).** Transport the DOMAIN presheaf
  `restr V (pushβ M.val)` over `Over V ⊆ Opens Y` ↔ `restr fV M.val` over `Over fV ⊆ Opens X` across
  the fully-faithful `f.opensFunctor` on the down-set of `fV`. **Build this as a standalone verified
  lemma `sliceDualTransport` FIRST** (the load-bearing field). NOT covered by `overSliceSheafEquiv`
  (sheaf-vs-presheaf, fixed-vs-varying value-cat — confirmed inapplicable).
- **Leg (B) — ground-ring reconciliation** `𝒪_X(fV) ≅ 𝒪_Y(V)` = `restrictScalarsRingIsoDualEquiv`
  (CLOSED; the right atom for the unit codomain).
Compose `isoMk (app := fun V => (sliceDualTransport ≪ₗ restrictScalarsRingIsoDualEquiv).toModuleIso)`
with thin-poset naturality (mirror `dualUnitIsoGen` / `dualIsoOfIso`). Skeleton in `analogies/dual252.md`.
- **ALTERNATIVE to weigh first (dual252 flag):** derive `dual_restrict_iso` from the CLOSED
  `tensorObj_restrict_iso` by uniqueness of monoidal inverses (dual = ⊗-inverse) via eval/coeval
  naturality — sidesteps leg (A) entirely if the inverse-uniqueness glue is cheaper. Try this FIRST if
  it looks tractable; fall back to (A)+(B) otherwise.

### Required cleanup (prover owns this file; lean-auditor aud251 MUST-FIX):
- Relabel the module header at `DualInverse.lean:25`: "dual_isLocallyTrivial **CLOSED** (iter-251)" →
  "**TRANSITIVELY PARTIAL** (depends on `dual_restrict_iso` Step-4 sorry at L254)". It compiles only
  because the Step-4 sorry produces an `Iso` axiomatically; the "CLOSED" label is false.
- Fix the "Uses (all CLOSED):" line at ~L293 that lists `dual_restrict_iso` as STUB (internal inconsistency).

**Bar:** close `homOfLocalCompat` (frontier base, deps all closed) at minimum; attempt `dual_restrict_iso`
Step-4 via the inverse-uniqueness shortcut OR the (A)+(B) build. Leave real compiling partial state + a
one-line handoff naming which route was tried and the exact residual if it resists.

**Reversing signals (armed):**
- `homOfLocalCompat` (all deps closed) does NOT close → genuine gluing-engine difficulty; re-scope /
  blueprint expansion before re-dispatch.
- `dual_restrict_iso` leg (A) `sliceDualTransport` resists after a genuine attempt → switch to the
  inverse-uniqueness shortcut next iter (do NOT thrash leg A).

**Guardrails:** stay in `DualInverse.lean`; do NOT edit `TensorObjSubstrate.lean` (TS-cmp owns it).
Do NOT close `exists_tensorObj_inverse` this iter (different file; future consolidation).
