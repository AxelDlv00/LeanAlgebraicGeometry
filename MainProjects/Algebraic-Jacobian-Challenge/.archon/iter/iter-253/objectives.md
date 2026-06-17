# Iter-253 objectives (prover-facing detail)

Two parallel lanes (M=2), both `[prover-mode: prove]`, both reduced to bounded mechanical residuals.
Blueprint source of truth: `chapters/Picard_TensorObjSubstrate.tex` (consolidated; covers both files),
refreshed this iter by bw253 + bw253b + bc253.

---

## Lane TS-cmp — `Picard/TensorObjSubstrate.lean`

Critical path A.1.c.sub: close the D1′ helper → D1′ → attempt D3′ → D4′ stretch.

### STEP A (PRIMARY) — close `sheafifyTensorUnitIso_hom_natural` (sorry ~L1993)
The whisker route is **DEAD** (verified iter-252; do NOT retry the `letI instMS`/`whisker_exchange`
approach). The committed body already descends to the element level; finish it.

Blueprint roadmap: `lem:sheafify_tensor_unit_iso_natural` proof (bw253b) — the element-level argument:
1. The body is already at `Hom.ext → simp → erw[comp_app, tensorHom_app] → ModuleCat.hom_ext → ext x`,
   leaving the goal an instance-free identity on `x : (P ⊗ Q).obj U`.
2. `induction x using TensorProduct.induction_on`:
   - **zero / add**: formal — feed the `map_zero` / `map_add` lemmas of the bundled `ModuleCat.Hom.hom`
     explicitly (the iter-252 prover noted `simp only [map_add]` did NOT auto-fire on
     `ModuleCat.Hom.hom (…) 0` / `(…) (a+b)` — feed the right `ModuleCat.Hom.hom`-application +
     `map_zero`/`map_add` lemmas by hand).
   - **tmul `m n`**: the value factors as the tensor of the two single-argument legs; close with the
     sectionwise sheafification-unit η-naturality read off at `.app U` on `m` and `n` separately —
     `(sheafificationAdjunction (𝟙 …)).unit.naturality p` and `… q` — after a `restrictScalarsId_map`
     strip to reconcile the carrier spelling. Use the ModuleCat tmul-evaluation lemmas for
     `ModuleCat.MonoidalCategory.tensorHom` on the pure tensor.
3. The `erw [comp_app ×4, tensorHom_app ×6]` carrier-bridge idiom + the
   `MonoidalCategory.whiskerLeft/Right`-unfold-to-`tensorHom` trick (iter-252) are reusable here and
   for D3′.

### STEP B — close D1′ `pullbackTensorMap_natural` (sorry ~L2022)
4-square paste. Merge `a_Y.map δ ≫ S3 ≫ S4` into `a_Y.map Ψ`; move S1 by NatTrans naturality;
discharge via `δ_natural` + `pullbackValIso_hom_natural` (CLOSED) + the Step-A output
(`sheafifyTensorUnitIso_hom_natural`). Assembly plan in the iter-251 task result + the corrected
blueprint D1′ sketch (`lem:pullback_tensor_map_natural`, now describing the section-level route).

### STEP C (attempt) — D3′ `pullbackTensorMap_restrict` (`lem:pullback_tensor_map_basechange`)
Mirror CLOSED `pullbackObjUnitToUnit_comp` (`_η`→`_δ`) at the PRESHEAF level + the iter-250 `.val`-friction
kit; re-derive the presheaf conjugate-pullbackComp identity. Armed: `analogies/d3-251.md`.

### STEP D (stretch) — D4′ `pullbackTensorIsoOfLocallyTrivial` only if D3′ closes → `IsInvertible.pullback`.

**Bar:** close STEP A + D1′ at minimum (both de-risked: in-file element recipe + blueprint roadmap);
attempt D3′; leave a REAL compiling partial + a one-line handoff naming the EXACT residual if D3′ resists.
**Reversing signal:** if STEP A does NOT close even with the element-level recipe + blueprint roadmap →
STOP, escalate to the pc253b SECONDARY corrective (Mathlib-analogy consult on `TensorProduct.induction_on`
over a sheafified module / the bundled `ModuleCat.Hom.hom` plumbing) — NOT a 4th approach pivot.
**Guardrails:** do NOT touch `exists_tensorObj_inverse` (~L708). Do NOT revive the general Lan build.
Keep the file COMPILABLE at every checkpoint (DualInverse.lean imports it).
**Minor cleanup (you own this file):** the `// Next iter:` annotation inside the STEP-A residual
(~L1986) goes stale once the sorry closes — update or drop it. The `set_option
backward.isDefEq.respectTransparency false` (L1657) + the elevated-heartbeat sites are deferred-polish,
do NOT churn them.

---

## Lane TS-inv — `Picard/TensorObjSubstrate/DualInverse.lean`

Dual-inverse chain: close `homOfLocalCompat` → attempt `dual_restrict_iso` Step-4.

### STEP A (PRIMARY) — close `homOfLocalCompat` (sorry ~L510)
Frontier base; `homLocalSection` (the load-bearing local section incl. naturality) is CLOSED axiom-clean.
The scaffold (hom-sheaf `H`, `iSup U = ⊤`, `existsUnique_gluing` fed `homLocalSection U f`) compiles.
Close the three residual pieces — blueprint roadmap in `lem:sheafofmodules_hom_of_local_compat` proof
(sub-step (a) now spells out the HEq bridge, bw253):
- **(a)** `IsCompatible H.1 U (homLocalSection U f)`: transport the overlap-agreement hypothesis (`HEq`)
  through the `eqToHom`-conjugation built into `homLocalSection` (its app/naturality), collapsing the
  two-route difference via `Subsingleton.elim` on parallel `(Opens X)ᵒᵖ` morphisms, into the honest
  equality of the two `homLocalSection` restrictions as sections of `H` over `U_i ⊓ U_j`.
- **(b)** glued `op ⊤`-section → morphism: `⊤` terminal in `Opens X`, so use `presheafHomSectionsEquiv`
  / `sheafHomSectionsEquiv` (the `op ⊤ ↔ .sections` bridge), NOT a hand-unfold of the `⊤`-section.
- **(c)** sectionwise `𝒪_X`-linearity `hg` (holds on each `U i` since `g|_{U i} = f i`; ambient presheaf
  separated ⇒ global), then `Scheme.Modules.homMk g hg : M ⟶ N`.

### STEP B (attempt) — `dual_restrict_iso` Step-4 (sorry ~L256)
Armed `analogies/dual252.md` (the iter-251 plan was UNDER-SCOPED: `dual` is NOT sectionwise). Try, in
order: (1) the **inverse-uniqueness shortcut** from CLOSED `tensorObj_restrict_iso` if tractable;
(2) else leg (A) slice-site Hom base-change `sliceDualTransport` (build standalone first) + leg (B)
`restrictScalarsRingIsoDualEquiv`. `overSliceSheafEquiv` is confirmed inapplicable to leg (A).

**Bar:** close `homOfLocalCompat` at minimum (deps all closed, blueprint-armed); attempt
`dual_restrict_iso` Step-4; leave real partial + a one-line handoff naming which route was tried.
**Reversing signals:** `homOfLocalCompat` does NOT close → gluing-engine difficulty, re-scope before
re-dispatch; leg (A) resists → switch to the shortcut, do NOT thrash leg A.
**Guardrails:** stay in `DualInverse.lean`; do NOT edit `TensorObjSubstrate.lean`; do NOT close
`exists_tensorObj_inverse` this iter.
**Minor cleanup (aud252):** the stale planner note at L322–323 ("`dual_unit_iso` … a small sorry if
needed") is now wrong — `dual_unit_iso` is CLOSED axiom-clean; update or drop the note.
