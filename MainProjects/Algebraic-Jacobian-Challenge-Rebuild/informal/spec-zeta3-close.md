# Brick spec — ζ3: close (C1), `PicEtAff.unit_injective`

*Written 2026-07-14 (Fable orchestrator). Consumer: one Fable implementation agent — this
is the (C1) close, the mathematically hardest remaining step of the étale-separatedness
campaign. The deliverable CONTRACT is binding; the route below is the designed one, but
you own the organization.*

## Mission

**Deliverable contract:** `theorem PicEtAff.unit_injective : Function.Injective
(PicEtAff.unit C A)` (statement shape per the docstring of
`AlgebraicJacobian/Picard/EtaleSeparatedness.lean` — the file exists, ζ1 lives there,
the target is only docstring text; write the real theorem there or in a sibling file),
kernel-green, axiom-clean, no sorry. This is (C1), Kleiman 2.5(1): the one-step-plus unit
of the étale-sheafified Picard construction is injective.

**Staged fallback (acceptable landing points, in order of preference):** (1) full
contract; (2) the kernel lemma `ker(CechPic X_A → CechPic X_B) ⊆ range(p_A^*)` (or the
equivalent `∃ M, p_A^* M = L` statement) with the final `unit_injective` unfold left as a
stated theorem with a design note; (3) the largest green committed prefix with a precise
frontier report. Never a red tree, never a sorry in the final state.

## The designed route (worksheet + landed hand-offs)

Unfold `unit C A x = 1` via `mk_eq_mk_iff` + essential uniqueness of maps out of
`(.self A).Carrier`: for some presented étale cover `B := E.Carrier` and `x = relPicMk L`
(`L : CechPic X_A`), the hypothesis becomes (via `relPicMap_mk` + `mem_picFromBase_iff`,
on-the-nose equations): ∃ `N : CechPic (Spec B)` with `p_B^* N = (C ◁ g)^* L`.
Goal: `∃ M : CechPic (Spec A), p_A^* M = L` (then `x = 1` by `mem_picFromBase_iff`).

Landed inputs (verify shapes with the LSP; the reports are in the ledger):

1. Present `N` by a trivializing family / basic refinement: `TrivializingFamily`,
   `𝒩.BasicRefinement P`, `P.coverCocycle γ`, `P.pic γ`, `pic_eq_picClass`,
   `TrivializingFamily.pic_cocycle` (`Picard/CechPicSurjective.lean`,
   `PicAffineCover.lean`, `PicAffine.lean`).
2. `Over.exists_coherentCechWitness C L 𝒩 γ h : Nonempty (CoherentCechWitness k A B 𝒩 γ)`
   (ζ2·i, committed e5417b02a2) — the coherent witness `θ'` for exactly this hypothesis.
3. `Over.assemblyUnit P θ'` with `Over.isDescentCocycle_assemblyUnit`,
   `Over.tensorCollapse_assemblyUnit`, and the hand-off
   `Over.mapAlgebra_picClass_assemblyUnit : Pic.mapAlgebra A Γ(Spec B,⊤)
   ((isDescentCocycle_assemblyUnit P θ').picClass) = P.pic γ` (ζ2·ii, committed
   f112ffdeda). Read the "Notes for the ζ3 spec-writer" section of
   `informal/spec-zeta2iib-pi-assembly.md`'s companion report in the task comments, and
   the header of `Picard/WitnessAssembly.lean` for the `local instance` reactivation
   line and the exact index-family spelling for defeq.
4. The affine dictionary both ways: `cechPicEquivPic : X.CechPic ≃* CommRing.Pic Γ(X,⊤)`
   (`CechPicSurjective.lean:283`), naturality `toPic_map`/`toPic_mapAlgebra`
   (`CechPicToPicNaturality.lean`), cocycle base change (`LocalizationCocycleBaseChange`).
5. ε1/ε2 and the ζ2·P toolkit for anything that must cross the projection `p`
   (`ProjectionUnits.lean`, `UnitDescentComposite.lean`, `AmitsurCochain.lean`), and the
   pullback calculus (`UnitsGlobalPullback.lean`, `CoherentWitnessCochains.lean`).

Define `M := cechPicEquivPic.symm (picClass (assemblyUnit P θ'))` over `Spec A` (cross
`Γ(Spec A,⊤) ≅ A` once, the `WitnessAway.lean` way). The remaining hard content is the
on-the-nose equality **`p_A^* M = L` in `CechPic X_A`**. Designed argument (the fppf
`descend_coboundary` analogue — worksheet `informal/c1-etale-separatedness-assembly.md`
ζ3 + "Original prose route" step 3): consider `L / p_A^* M`; it is trivialized on `X_B`
(both factors are — `L` by the hypothesis and construction of `v` from its witness, `M`
by `mapAlgebra_picClass`+the dictionary), and its `B ⊗[A] B`-descent datum is a
coboundary BY CONSTRUCTION of `v` (the witness θ' was corrected to be the transition
datum of `v`); a class trivialized on `X_B` whose descent unit descends through ε1 to a
coboundary is `1` — check after pullback with `Scheme.CechPic.mk_eq_one_iff` /
`mk_injective` (refinement injectivity, `RefinementInjectivity.lean`) and only global
units crossing `p` (ζ2·P). ALTERNATIVE organization if the by-construction tracking
fights you: prove the standalone kernel lemma
`∀ L, CechPic.map pB' ((C ◁ g)^* L)`-triviality ⟹ `L ∈ range p_A^*` — same tools,
cleaner induction. Decide early, record the decision.

Then unfold to `unit_injective` via `injective_iff_map_eq_one` + `mk_eq_mk_iff` +
`relPicMk` calculus (shapes catalogued in `informal/wave3-picard-design.md` Q1/Q4 and
the `PicEtAff.lean`/`PicEtAffMap.lean`/`RelPic.lean` APIs: `relPicMk_eq_relPicMk_iff`,
`mem_picFromBase_iff`, `relPicAlgMap_congr`, `descentClasses`).

## Constraints (binding — the kernel discipline that saved ζ2·i and ζ2·ii)

- Opaque `def`s for repeated cover/class/unit data + named `≤`/refinement lemmas; NO
  `rw`/`simp only ... at` on hypotheses mentioning concrete curve/Spec towers; one
  abstract lemma per rewrite-heavy step, instantiated by a single application; every
  uniqueness over the base where pi-ext lives (`B ⊗[A] B`), never over `A`.
- Files ≤ 500 lines; mathlib naming + complete docstrings; `set_option autoImplicit
  false`; no new axioms; do NOT touch `Challenge.lean`; wire new files into
  `AlgebraicJacobian.lean` (a blueprint agent edits only `blueprint/**` concurrently).
- Search before proving (lean_local_search / lean_loogle / lean_leansearch) — especially
  the `CechPic` mk-calculus: most single steps exist.

## Verification (FOREGROUND, non-negotiable)

Iterate with the lean-lsp MCP; never two lake builds at once. When done: root
`lake build` blocked to completion (paste tail), `lean_verify` on `PicEtAff.unit_injective`
and every new keystone (axioms exactly `[propext, Classical.choice, Quot.sound]`),
`grep -n -w sorry` on touched files (exits 1 on zero matches — no `&&`-chaining).
Do NOT run git; do NOT commit.

## Report format (final message)

Files (line counts) · keystones with one-line statements · which organization ζ3 took
and why · build tail verbatim · lean_verify outputs verbatim · frontier if staged ·
what the Layer-2 (`picEt`, inbox I-0140) spec-writer must know, in particular the exact
form of the sheaf-on-affines corollary this makes available.
