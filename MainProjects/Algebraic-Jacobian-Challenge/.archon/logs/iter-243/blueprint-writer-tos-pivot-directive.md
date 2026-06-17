# blueprint-writer directive — Picard_TensorObjSubstrate.tex — Lane A route PIVOT (recipe #3)

## Chapter
`blueprint/src/chapters/Picard_TensorObjSubstrate.tex`, section `sec:tensorobj_pullback_monoidality`
(currently L2564–~2960). You edit ONLY this chapter.

## Why this rewrite (strategy context — the slice that matters)
The substrate goal is `lem:isinvertible_pullback` (`IsInvertible.pullback`: pullback preserves
⊗-invertibility), the A.1.c prerequisite for the relative Picard functor. The chapter currently routes it
through `lem:pullback_tensor_iso` — the GENERAL pullback-tensor comparison `f^*(M⊗N) ≅ f^*M ⊗ f^*N` for
ARBITRARY M,N — built via a "concrete strong-monoidal pullback P = sheafify∘(sectionwise extendScalars)".

**That route is now empirically confirmed Mathlib-scale and is being DESCOPED.** A prover attempt
(iter-242) established: the concrete model P needs `PresheafOfModules.extendScalars` (absent in Mathlib)
and a topological inverse-image functor (an unbuilt left Kan extension along `(Opens.map f.base).op`).
Stacks proves the general iso (`lemma-tensor-product-pullback`) but its proof is literally "Omitted" — it
is standard math with no slick formalization. Building it is a genuine multi-hundred-LOC Mathlib-scale
project.

**The general iso is also UNNECESSARY.** The entire downstream path (relative Picard functor, Quot
embedding, tangent computation, Albanese UP) only ever pulls back INVERTIBLE modules. So we descope to the
invertible case and prove `IsInvertible.pullback` by a **local-trivialization route** that sidesteps the
absent inverse-image entirely. strategy-critic ts243 VERIFIED this route is SOUND and a genuine difficulty
reduction (the hardest prerequisite changes from an *absent Mathlib construction* to a *provable lemma over
existing stalk/restriction machinery*); progress-critic ts243 flagged Lane A CHURNING and named the
corrective as exactly this: write recipe #3's full path into the blueprint BEFORE the next prover dispatch.

## What landed in iter-242 (now reusable, must be pinned)
Two presheaf-level instances were proved axiom-clean (currently UNPINNED in the chapter — this is a
lean-vs-blueprint MAJOR finding):
- `AlgebraicGeometry.Scheme.Modules.presheafPushforwardLaxMonoidal` — `(PresheafOfModules.pushforward φ)`
  is lax monoidal (the `μ_G` comparison), for a CommRingCat-factored ring-presheaf map φ.
- `AlgebraicGeometry.Scheme.Modules.presheafPullbackOplaxMonoidal` — `(PresheafOfModules.pullback φ)` is
  oplax monoidal, i.e. carries the canonical comparison map `δ : f^*(A⊗B) ⟶ f^*A ⊗ f^*B` AT THE PRESHEAF
  LEVEL, built via Mathlib's `Adjunction.leftAdjointOplaxMonoidal` on the lax pushforward.

These REFUTE the chapter's current claim (in the `lem:pullback_tensor_iso` proof, ~L2718–2723) that there
is "no `pushforward.LaxMonoidal`" — there now IS, at the presheaf level. The presheaf comparison `δ` exists;
the only open content is upgrading `δ` to an ISO.

## In-tree decls VERIFIED available (cite as already-proven; do NOT re-derive)
- `lem:pullback_unit_iso` (`pullbackUnitIso`, L2828) — `f^*𝒪_X ≅ 𝒪_Y`, DONE.
- `IsLocallyTrivial.pullback` (`LineBundlePullback.lean:156`) — `f^*` of a locally-trivial module is locally
  trivial. **PROVEN, sorry-free** (the docstring saying "named typed sorry" is STALE).
- `tensorObj_isLocallyTrivial` (`TensorObjSubstrate.lean:536`, `lem:tensorobj_preserves_locally_trivial`) —
  ⊗ of two locally-trivial modules is locally trivial. PROVEN.
- `isIso_of_isIso_restrict` (`TensorObjSubstrate.lean:567`, `lem:isIso_of_isIso_restrict`) — a morphism of
  `Scheme.Modules` that is iso after restriction to every open of a cover is iso. PROVEN.
- `sheafifyTensorUnitIso` (`TensorObjSubstrate.lean:1084`) and the `sheafificationCompPullback`
  device used in `lem:tensorobj_restrict_iso` (Steps 1–2) — the sheafification-transport machinery.
- `def:scheme_modules_isinvertible` (`IsInvertible M := ∃ N, Nonempty (M ⊗ N ≅ 𝒪)`).

## REQUIRED EDITS

### (1) Rewrite the section intro (L2566–2618) — replace the concrete-P framing
The current intro argues the strong-monoidal-P route is "primary" and dismisses local triviality as "a
mirage on the present carrier." **This dismissal is now wrong for our actual route and must be corrected
carefully.** The crucial distinction the new intro MUST draw:
- The dismissal correctly applies to the REVERSE bridge `IsLocallyTrivial ⟹ IsInvertible` (recovering
  invertibility FROM local triviality = the shelved dual/tensor-inverse manufacture). That stays off-path.
- It does NOT apply to our route, which builds the EXPLICIT witness `f^*N` (never recovering invertibility
  from local triviality) and uses local triviality ONLY to prove the comparison map `δ_sheaf` is an
  ISOMORPHISM on the specific invertible pair. This is the FORWARD direction `IsInvertible ⟹
  IsLocallyTrivial` (invertible ⟹ locally free of rank 1), which is genuinely available.

State plainly: the general `pullbackTensorIso` is descoped (Mathlib-scale: no `PresheafOfModules.extendScalars`,
no concrete topological inverse image; Stacks' own proof is "Omitted"); only the invertible case is needed;
the route is local trivialization. Keep the (still-correct) negative result that an oplax map alone does not
preserve invertibles (`Γ(ℙ¹,𝒪(1))=0` counterexample). ADD a guardrail negative result (strategy-critic
ts243): do NOT prove `δ_sheaf` iso STALKWISE — that revives the abandoned d.2 stalk-tensor sink; use the
cover route via `isIso_of_isIso_restrict`.

### (2) Add two pin blocks for the landed presheaf instances
Add, early in the section (before `lem:pullback_tensor_map` below), two `\begin{lemma}` blocks:
- `lem:presheaf_pushforward_laxmonoidal`, `\lean{AlgebraicGeometry.Scheme.Modules.presheafPushforwardLaxMonoidal}`
  — state: the presheaf pushforward along a CommRingCat-factored ring-presheaf map is lax monoidal (the `μ`
  comparison), as the composite of the strong-monoidal `pushforward₀OfCommRingCat` with the lax
  `restrictScalars φ`. These are presheaf-level (not `SheafOfModules`-level).
- `lem:presheaf_pullback_oplaxmonoidal`, `\lean{AlgebraicGeometry.Scheme.Modules.presheafPullbackOplaxMonoidal}`,
  `\uses{lem:presheaf_pushforward_laxmonoidal}` — state: the presheaf pullback is oplax monoidal, carrying
  the canonical comparison `δ : f^*(A⊗B) ⟶ f^*A ⊗ f^*B` via `Adjunction.leftAdjointOplaxMonoidal` on the lax
  pushforward. Note explicitly: `δ` is only a MAP; upgrading to an iso is the remaining content.
  (No external source — Archon-local infrastructure; no SOURCE QUOTE.)

### (3) Convert `lem:pullback_tensor_iso` (L2620–2733) to a DESCOPED remark
Keep the block (it documents the general fact + why it is hard) but reframe it as OFF the critical path:
- Statement stays mathematically (cite Stacks `lemma-tensor-product-pullback`, quote already present).
- Add a prominent note: this GENERAL iso is **descoped** — confirmed Mathlib-scale (the concrete model needs
  the Mathlib-absent `PresheafOfModules.extendScalars` + a topological inverse-image left Kan extension;
  Stacks' proof is "Omitted"), and it is NOT needed on any project path (only the invertible case is). The
  substrate uses the local-trivialization route (`lem:isinvertible_pullback`) instead.
- Replace the stale "no `pushforward.LaxMonoidal`" claim in the proof with the corrected statement: the
  presheaf-level lax/oplax structure now EXISTS (`lem:presheaf_pushforward_laxmonoidal`,
  `lem:presheaf_pullback_oplaxmonoidal`) and yields the comparison MAP `δ`; the true obstacle is upgrading
  `δ` to an iso, which the concrete-model route would need the absent inverse image for.
- Keep `\lean{...pullbackTensorIso}` ONLY if you mark it clearly as an unbuilt/off-path target; otherwise
  DROP the `\lean{}` pin (the decl does not exist and is not being built). Prefer DROPPING the `\lean{}` pin
  and stating the decl is not formalized (off-path).

### (4) Add `lem:pullback_tensor_map` — the sheaf-level comparison MAP `δ_sheaf` (NEW, the first brick)
`\lean{AlgebraicGeometry.Scheme.Modules.pullbackTensorMap}` (the prover will name the decl; use this name).
`\uses{lem:presheaf_pullback_oplaxmonoidal, def:scheme_modules_tensorobj, lem:tensorobj_restrict_iso}`.
State: for `f : Y ⟶ X` and `M, N : X.Modules`, the canonical comparison MORPHISM (not yet iso)
`δ_sheaf : (pullback f).obj (M ⊗_X N) ⟶ (pullback f).obj M ⊗_Y (pullback f).obj N`, obtained by transporting
the presheaf-level oplax `δ` (`lem:presheaf_pullback_oplaxmonoidal`) through sheafification — the same
`sheafificationCompPullback` Steps 1–2 used in `lem:tensorobj_restrict_iso`, with the unit/right-hand-side
reconciliation supplied by `sheafifyTensorUnitIso`. This is a MAP for GENERAL M,N (Archon-original; no
external source). It is the carrier the invertible-case iso argument acts on.

### (5) Add `lem:isinvertible_implies_locallytrivial` — the FORWARD bridge (NEW)
`\lean{AlgebraicGeometry.Scheme.Modules.IsInvertible.isLocallyTrivial}` (suggested decl name).
State: for `M : X.Modules` on a SCHEME `X`, `IsInvertible M ⟹ LineBundle.IsLocallyTrivial M` (each point has
an affine neighborhood on which `M ≅ 𝒪`). SOURCE = Stacks `lemma-invertible-is-locally-free-rank-1`
(read references/stacks-modules.tex L4159–4196 for the statement+proof; quote verbatim) together with
`lemma-invertible` (L4066–4137: invertible ⟺ ∃N M⊗N≅𝒪, and in that case M is locally a direct summand of a
finite free module — hence finitely presented). Proof sketch (from Stacks): an invertible M has, at each x,
`M_x ⊗_{R_x} N_x ≅ R_x` (stalk of the witness iso `M⊗N≅𝒪`, via the d.2 stalk-tensor commutation
`stalkTensorIso` which is already proven), so `M_x` is an invertible module over the LOCAL ring
`𝒪_{X,x}`, hence `M_x ≅ 𝒪_{X,x}` (free of rank 1; the scheme hypothesis supplies local stalks); since M is
finitely presented (lemma-invertible), a free stalk extends to a free neighborhood
(`lemma-finite-presentation-stalk-free`), giving `M ≅ 𝒪` on an affine neighborhood. Flag in the prose that
this is the route's genuine new cost (the stalk-local-ring + finite-presentation argument over
`SheafOfModules`); the d.2 stalk-tensor ingredient is already in-tree.

### (6) Rewrite `lem:isinvertible_pullback` proof (L2913–~2950) to the local-trivialization route
Update `\uses` to `{def:scheme_modules_isinvertible, lem:pullback_tensor_map,
lem:isinvertible_implies_locallytrivial, lem:pullback_unit_iso, lem:isIso_of_isIso_restrict,
lem:tensorobj_preserves_locally_trivial}` (DROP `lem:pullback_tensor_iso`). Keep the Stacks
`lemma-pullback-invertible` SOURCE QUOTE (already present). New proof body, in project notation:
- Witness: `f^*N` for the membership witness `e : M ⊗ N ≅ 𝒪_X` of `IsInvertible M`.
- The required iso `f^*M ⊗ f^*N ≅ 𝒪_Y` is the composite
  `(asIso δ_sheaf).symm ≫ (pullback f).mapIso e ≫ pullbackUnitIso`, where `δ_sheaf = pullbackTensorMap M N`
  (`lem:pullback_tensor_map`) is shown to be an ISO **for this invertible pair**:
  - M, N invertible ⟹ locally trivial (`lem:isinvertible_implies_locallytrivial`). Take a common affine
    trivialising cover `{U_i}` of `X` (M|U_i ≅ 𝒪, N|U_i ≅ 𝒪); the preimages `{f⁻¹U_i}` cover `Y`.
  - By `isIso_of_isIso_restrict` it suffices that `δ_sheaf` restricted to each `f⁻¹U_i` is an iso. On
    `f⁻¹U_i`, `f^*M`, `f^*N`, and `f^*(M⊗N)` all restrict to `𝒪` (via `IsLocallyTrivial.pullback` /
    naturality of restriction with pullback), and `δ_sheaf` restricts to the canonical comparison
    `𝒪 ⊗ 𝒪 ≅ 𝒪`, which is an iso. (Flag the "restricts to the canonical comparison" compatibility as the
    crux step the prover must discharge.)
- Conclude `IsInvertible (f^*M)` with witness `f^*N`.
This mirrors Stacks `lemma-pullback-invertible` but realises its `lemma-tensor-product-pullback` step only on
the invertible pair (via local trivialisation), never building the general comparison.

## Out of scope (do NOT touch)
- The group-law section, dual-bridge sorries, the d.2 / `StalkTensor` blocks, `lem:tensorobj_restrict_iso`.
- Do NOT add or remove `\leanok` / `\mathlibok` (the sync phase owns `\leanok`).
- Do NOT alter `lem:pullback_unit_iso`, `lem:pullbackObjUnitToUnit_comp`, `lem:unitToPushforwardObjUnit_comp`.

## Citation discipline
Every new block deriving from Stacks needs a `% SOURCE:` + verbatim `% SOURCE QUOTE:` read from
`references/stacks-modules.tex` (you are authorised `references/**`; re-read the named line ranges and quote
character-for-character). The δ_sheaf map and the `isinvertible_pullback` assembly are Archon-original —
no external quote (they stand on the proof sketch). Keep the existing `lemma-pullback-invertible` and
`lemma-tensor-product-pullback` quotes intact.
