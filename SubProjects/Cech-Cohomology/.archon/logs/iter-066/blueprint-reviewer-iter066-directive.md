# Blueprint-reviewer directive — iter-066

Whole-blueprint audit (per-chapter completeness + correctness checklist), as usual.

Focus this iter (do NOT scope-limit, but pay extra attention here): the consolidated
chapter `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex` was edited this iter
(blueprint-writer `comp-iter066` + blueprint-clean `iter066`). The edits:
- Split `lem:open_immersion_pushforward_acyclic` (part (1), `R^q j_* = 0`, now PROVEN) out
  of `lem:open_immersion_pushforward_comp` into its own block.
- Rewrote the part-(2) proof of `lem:open_immersion_pushforward_comp` onto the
  adjoint-preserves-injectives categorical route: `pushforward j` preserves injectives
  (right adjoint of the mono-preserving `pullback j ≅ restrictFunctor j`) ⟹ `j_* I^n`
  injective ⟹ `f_*`-acyclic (via `Functor.IsRightAcyclic.ofInjective`); `hexact` = part (1)
  acyclicity on `H`; `eRes` = left-exact augmentation; `transport` = `pushforwardComp` +
  `isoRightDerivedObj`. The previous flawed "Serre vanishing on the affine `U∩f⁻¹V`" path
  (`U∩f⁻¹V` is not affine in general) was deleted.
- Corrected the φ'' (`lem:slice_reverse_ring_map`) codomain-bridge sketch to the actual
  definitional argument.
- Added `\mathlibok` anchors for `Scheme.Modules.pullbackPushforwardAdjunction` and
  `Scheme.Modules.pushforwardComp`; coverage edit folding `isZero_modules_of_isEmpty`.

This chapter gates the two live prover lanes this iter:
- `CechSectionIdentification.lean` — Stub 5 `lem:cechSection_complex_iso`, Stub 6
  `lem:cechSection_contractible` (NOT edited this iter; previously rated adequate).
- `OpenImmersionPushforward.lean` — `lem:open_immersion_pushforward_comp` part (2).

I need a clear per-chapter verdict (complete / correct + any must-fix-this-iter findings)
for `Cohomology_CechHigherDirectImage.tex` so I can decide whether to dispatch provers on
both files THIS iter. In particular: is the rewritten part-(2) proof correct and complete
enough to formalize, and is each of the four obligations (hacyc/eRes/hexact/transport)
specified at a formalizable level of detail?

Also surface the usual: broken `\uses{}`, isolated nodes, unstarted-phase proposals.
