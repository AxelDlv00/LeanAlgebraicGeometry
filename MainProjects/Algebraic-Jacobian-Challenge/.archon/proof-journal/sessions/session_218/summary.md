# Session 218 — review of iter-218

## Metadata
- **Iteration / session:** iter-218 / session_218
- **Sorry count:** project **80 → 80** (net **0**). TS-file code sorries **3 → 3**.
- **Build:** GREEN (0 errors; 1 known `ext`-pattern linter warning).
- **Axioms / blueprint-doctor:** no `axiom` decls; blueprint-doctor clean (the two
  iter-217 `\leanok`-inside-`\uses{}` corruptions are RESOLVED — writer ts218 reflowed them).
- **Targets attempted:** PRIMARY `exists_tensorObj_inverse` (the ⊗-dual, critical path);
  LAST/bonus SECONDARY = re-route `tensorObj_assoc_iso` onto `tensorObj_restrict_iso` +
  delete the vestigial whiskering/stalk apparatus (target 80→79).
- **Closed:** none.

## Outcome — the planner's cheapest reversal signal fired exactly as written

The iter-218 plan set the PRIMARY on `exists_tensorObj_inverse` with an explicit pre-committed
reversal signal: *"if the prover returns INCOMPLETE citing a genuinely Mathlib-absent primitive
(no Scheme.Modules-level internal-hom / dual / evaluation), that is the trigger to run a
mathlib-analogist round next iter rather than re-dispatching prove blindly."* The prover returned
exactly that. This is a clean, predicted INCOMPLETE-gate landing, not a surprise stall.

## Target 1 — `exists_tensorObj_inverse` (L1399) — BLOCKED (infrastructure missing)

**Goal:**
```lean
lemma exists_tensorObj_inverse {X : Scheme.{u}} {L : X.Modules}
    (hL : LineBundle.IsLocallyTrivial L) :
    ∃ Linv : X.Modules, LineBundle.IsLocallyTrivial Linv ∧
      Nonempty (tensorObj L Linv ≅ SheafOfModules.unit X.ringCatSheaf)
```

**Attempt 1 (blueprint dual route).** Set `Linv := ℋom_{𝒪_X}(L, 𝒪_X)`, show it locally trivial,
exhibit the contraction `L ⊗_X Linv → 𝒪_X` and prove it a global iso via the CLOSED
`tensorObj_restrict_iso` + `tensorObj_unit_iso`, mirroring `tensorObj_isLocallyTrivial` (L1349).

**Result:** blocked at step 1 — `Linv` cannot even be **named**, so no tactic state advances
(not even `refine ⟨Linv, ?_, ?_⟩`). Verified against on-disk Mathlib `b80f227`:
- `loogle MonoidalClosed (PresheafOfModules ?R)` → **0 results** (no internal hom on presheaves of modules);
- no `MonoidalClosed (SheafOfModules R)` / no `SheafOfModules`-level internal-hom, dual, or eval object
  (`CategoryTheory.sheafHom` lands in `Sheaf J (Type …)`, carrying NO 𝒪_X-module structure);
- the categorical "invertible object ⇒ inverse" escape is unavailable **by design** (no
  `MonoidalCategory (X.Modules)` for the varying structure sheaf — `commring-pic-is-skeleton-route`);
- object-level descent (glue a global `Linv` from local `𝒪_{U_i}` along `g_{ij}⁻¹`) is also
  Mathlib-absent — Mathlib has section-gluing (`existsUnique_gluing`) and "iso is local"
  (`Sheaf.isLocallyBijective_iff_isIso`) but NOT object assembly.

**Gate compliance:** per the PROGRESS.md INCOMPLETE gate + progress-critic ts218 PRE-CAUTION, the
prover did NOT push a `dual`-shaped helper-sorry forward (the iter-214 d.1 anti-pattern). It left
the typed `sorry` with a detailed in-code blocker comment and wrote the exact missing primitive +
full decomposition to `informal/exists_tensorObj_inverse.md`. The informal agent was called
(`--provider auto`, MOONSHOT key set) but returned **HTTP 401 Invalid Authentication**, so the
blocker analysis is Mathlib-source-derived, not LLM-sketch-derived.

**Missing primitive (mathlib-analogist / mathlib-build target):**
```
def Scheme.Modules.dual {X : Scheme.{u}} (M : X.Modules) : X.Modules            -- ℋom_{O_X}(M, O_X)
def Scheme.Modules.eval {X : Scheme.{u}} (M : X.Modules) :
    tensorObj M (dual M) ⟶ SheafOfModules.unit X.ringCatSheaf                    -- s ⊗ φ ↦ φ(s)
```
preferably presheaf-level then sheafify, mirroring how `tensorObj` sheafifies the presheaf tensor.

## Target 2 — SECONDARY re-route / `isLocallyInjective_whiskerLeft_of_W` (L632) — BLOCKED

The bonus −1 was: re-route `tensorObj_assoc_iso` (L1150) onto the closed `tensorObj_restrict_iso`
and delete the vestigial whiskering/stalk apparatus, eliminating the L632 sorry. `tensorObj_assoc_iso`
is a complete no-literal-sorry body but **transitively depends on the L632 sorry** through the live
`W_whiskerLeft_of_W` / `W_whiskerRight_of_W` chain (so it is NOT axiom-clean — see Key findings).
Both paths to the −1 are Mathlib-blocked:
- **(a) close L632 directly** needs the stalkwise route: d.1-bridge (`J.W` ⇔ stalkwise-iso on
  `Opens X`) + **d.2** (stalk-⊗ commutation over the varying ring) — d.2 is the largest absent piece;
  progress-critic explicitly warned against pushing it. A stalk-free route was ruled out (local
  bijectivity is per-section-covering-sieve, not a uniform cover) and the categorical `J.W.IsMonoidal`
  route is circular.
- **(b) re-route assoc onto restrict-iso + delete** needs **morphism-level descent** for
  `SheafOfModules` (glue local isos `tensorObj_restrict_iso`×2 + presheaf associator into a global
  morphism). Heavy/absent at this level — the local isos do not auto-assemble.

The prover correctly did NOT attempt a broken partial re-route (it would leave non-compiling gluing
scaffolding) and did NOT delete the dead code (deleting removes no sorry — the L632 sorry lives in
the LIVE `_of_W` chain — and only risks the build).

## Target 3 — `addCommGroup_via_tensorObj` (L1443) — out of scope, downstream of the inverse.

## Key findings / patterns

1. **`tensorObj_assoc_iso` is NOT axiom-clean — it transitively depends on the L632 `sorry`.** Both
   review subagents (lean-auditor ts218, lean-vs-blueprint-checker ts218) independently confirm the
   call chain `tensorObj_assoc_iso → W_whiskerLeft/Right_of_W → isLocallyInjective_whiskerLeft_of_W
   (L632 sorry)`. The iter-214 framing "associator ASSEMBLED, no sorry in its body" is literally true
   but obscured this transitive dependency; the project's group-law associator existence is therefore
   still gated on L632. (The prover's own task result already states this — the reviewers corroborate.)

2. **Two distinct Mathlib-absent infrastructure families now block the whole TS lane:**
   (i) **object-level** internal-hom/dual + evaluation for `SheafOfModules` (blocks the inverse), and
   (ii) **morphism-level** descent / stalk-⊗ commutation d.2 (blocks closing/retiring L632). Both are
   "build new Mathlib infrastructure" tasks, not proof-search tasks.

3. **Reviewer-confirmed honest docstrings on the closed work** — `tensorObj` (L990) and
   `tensorObj_functoriality` (L1005) docstrings now accurately say "fully defined, no sorry" (prover
   fixed them this iter). The inverse blocker comment is accurate (no laundering).

4. **`@[implicit_reducible]` over the L1443 sorry does NOT mask the metric** — lean-auditor confirmed
   `sorry_analyzer` still sees it and (the def not being an `instance`) TC synthesis never silently
   satisfies a downstream `AddCommGroup` from it. Hygiene concern only; retained to avoid the
   `classType` linter warning.

## Recommendations (next plan iter)
See `recommendations.md`. Headline: do NOT re-dispatch `prove` on either sorry; run the
mathlib-analogist (api-alignment) on the `SheafOfModules` dual/internal-hom primitive — the
progress-critic-scheduled trigger.

## Blueprint markers updated (manual)
- `Picard_TensorObjSubstrate.tex`, `lem:tensorobj_inverse_invertible`: added `% NOTE (review iter-218)`
  to the proof block — flags the Lean body is `sorry` (INFRASTRUCTURE MISSING), the dual/eval object
  is Mathlib-absent at `b80f227`, and points to `informal/exists_tensorObj_inverse.md`. (Addresses
  lean-vs-blueprint-checker ts218 MUST-FIX #1: the prose described the construction as executable.)
- `Picard_TensorObjSubstrate.tex`, `lem:tensorobj_assoc_iso`: added `% NOTE (review iter-218)` to the
  proof block — flags the blueprint/Lean ROUTE MISMATCH (Lean uses the whiskering route → transitive
  L632 sorry; blueprint describes the not-yet-realized gluing route) and that the `% SUPERSEDED …
  removed in iter-218` comments are premature (declarations remain LIVE). (Addresses lvb ts218 MAJOR.)

No `\mathlibok` added (no decl is a pure Mathlib re-export). No `\lean{...}` renames flagged. No stale
`\notready` present.

### `\leanok` note (NOT modified by review — sync owns it)
`sync_leanok` ran for iter-218 (sha `101077e7`, +0/−6) — its verdict is authoritative. lvb ts218 noted
3 sorry-free blocks (`lem:restrictscalars_ringiso_strongmonoidal`, `lem:presheaf_pushforward_adj_substrate`,
`lem:tensorobj_unit_iso`) currently lacking statement-`\leanok`; these were freshly pinned by writer
ts218, likely after sync's snapshot. Next sync should reconcile — NOT laundering, flagged for the plan
agent only.

## Notes (LOW)
- 4× `set_option backward.isDefEq.respectTransparency false` (L300/316/333/901) — legitimate defeq
  workarounds but a Mathlib-version-bump brittleness watch (lean-auditor minor).
