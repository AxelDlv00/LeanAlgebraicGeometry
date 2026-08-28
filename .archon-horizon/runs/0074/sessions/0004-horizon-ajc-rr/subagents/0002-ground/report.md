The root roll-up is explicitly off-limits to this lane, so the unrooted state is a genuine scope-forced consequence — not negligence. But it is undisclosed, and it matters. Here are my findings.

## Findings

**Nothing in this session's mathematical claims is wrong.** I could not break any of the seven commits' central assertions. The problems I found are about *coverage and disclosure*, not correctness.

### The one thing that actually needs action

**CONFIRMED — the entire 40-file, 9,797-line Ledger cone is unrooted, and therefore invisible to the standing axiom probe.** The root roll-up `/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian.lean` contains zero `RiemannRoch.Ledger.*` imports; I computed the transitive closure of the roll-up (214 modules reachable, 0 of them Ledger) and confirmed `lakefile.toml`'s `[[lean_lib]]` has no `globs`, so `lake build` green at 8,773 jobs says nothing about this cone. `scripts/axiom-frontier.lean:350` imports only `AlgebraicJacobian`, so none of the four new headline results are in the probe.

This is exactly trap (5) in the project's own `TO_USER.md:57`: "An unrooted module is not probed at all, because the root import never reaches it." The lane is *not at fault* for the state — the task explicitly forbids editing the root roll-up — but no docstring, commit message, or task comment discloses it. `grep -i 'unrooted\|roll-up'` across all six new files returns nothing. A reader of `chi_divisorSheaf_genus` has no way to learn that its clean axiom line is not measured by the workspace's standing check.

Secondary: none of the seven commits carry `Archon-Run`/`Archon-Task` trailers, while every sibling lane's commits do. Minor traceability gap.

### Claims I verified and that hold

**Unconditionality is honest (CONFIRMED).** I wrote my own restatement of `chi_divisorSheaf_genus` with only the three curve binders and proved it from the session's theorem, plus an independent `infer_instance` synthesis of `Module.Finite k (Sheaf.HModule (C.left.moduleKSheaf k) 1)` at my own site. Both report `[propext, Classical.choice, Quot.sound]`. Zero sorries in the Ledger cone, zero `axiom`/`native_decide`/sorried instances. The two finiteness binders are genuinely synthesised via `Finiteness.lean:388`, not assumed.

**The genus bridge is a real identification, not a rename (CONFIRMED).** I checked the negative case, which is the informative one: `example ... : ledgerGenus C = genus C := by rfl` **fails** with "not definitionally equal". So the two `finrank`s are of genuinely different modules, and the equality holds only through `Abelian.Ext.chgUnivLinearEquiv` (`Cohomology/MayerVietorisCore.lean:102`), a real `≃ₗ` over mathlib's `chgUniv`, sorry-free. The docstring's disclaimer at `GenusBridge.lean:32-39` is accurate: it explicitly says no `LinearEquiv` between the carriers is produced and no functorial/naturality comparison is claimed.

**Non-vacuity is real (CONFIRMED).** All three geometric binders synthesise at `Adelic.p1Over k` in my own probes; `chi_divisorSheaf_p1Over` and `moduleFinite_genus_carrier_p1Over` are axiom-clean at my site. The `finrank`-defaulting reasoning at `NonVacuity.lean:83-86` is **correct** — I confirmed `Module.finrank_of_infinite_dimensional` makes `finrank = 0` for non-finite modules, so the finiteness probe does rule out the trivial satisfaction. `NonVacuity.lean:38-42` volunteers the right caveat unprompted: genus zero is degenerate, "the test rules out emptiness, not weakness."

**Scope discipline is clean (CONFIRMED).** All seven commits touch only `AlgebraicJacobian/RiemannRoch/Ledger/**` — I counted files outside that prefix (0) and AJCR files (0) per commit. No `WeilDivisor.lean`, `Picard/**`, `Jacobian.lean`, `AbelJacobi.lean`, `Cohomology/**`, root roll-up, or blueprint file. The `GroundProbe*.lean` files at the project root are dated 15:52, predate this session, and are gitignored.

**Port fidelity is as advertised (CONFIRMED).** Diffing each ported file against its AJCR original: the differences are import-path rewrites only, except the two deliberate collision fixes and `ChiCurve.lean`'s `genus` → `ledgerGenus` rename with an honest explanatory comment.

**Co-rootability re-verified independently (CONFIRMED).** I built a probe importing `AlgebraicJacobian` plus all 40 Ledger modules simultaneously; it elaborates and prints `COROOT OK`, so no duplicate fully-qualified name remains. Both fixes at `3809f4e9a` are the right kind: AJC's `linearEquiv₀_mk₀_comp` (`Cohomology/StructureSheafModuleK/SectionsBridge.lean:91`) really is more general (`Ring R`, universes `u₂ v₂ w`) than the deleted AJCR copy (`CommRing R`, single `Type u`), and the deleted one had zero references outside its own proof. The `private` on the two `HomogeneousLocalization` lemmas resolves rather than hides: `#check` on both public names unambiguously returns AJC's `Picard/RigidPushforwardP1ChartRing.lean` versions with no ambiguity error. I also checked the adjacent instance-duplication risk (TO_USER trap 6) — only one `instAlgebraBase` exists; the ported file's algebra instance is anonymous, so no competing instances.

### Overstatement hunt: came up clean

I read all six new docstrings adversarially looking for the (a)/(b)/(c) conflation the task warns about. **No file claims H1 vanishing, extension-uniformity, or global generation.** Grepping the new files for `vanish|global gener|uniform` returns only correct uses: "the *weighted* degree vanishes", and "an integral extension of an algebraically closed field" (field theory, not field-extension uniformity). The word "unconditional" appears only about finiteness binders being discharged, which is what was actually proved.

`ResidueOneAlgClosed.lean:46-54` presents `[IsAlgClosed K]` as essential in the strongest terms — "essential and not incidental", "over a general base field the weighting is real", and it explicitly disclaims forward progress: "this file is no evidence that such an argument is close." `PrincipalCompare.lean:52-60` correctly stops at coefficients: "This identifies **coefficients at a point**. It is not yet the divisor-level statement." It even flags that a sign error would be invisible in any degree-zero statement, which is the right worry.

One item to note, not a defect: `PrincipalCompare.lean:59` says the remaining transport is "bookkeeping, not mathematics." An uncommitted follow-up file, `/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/RiemannRoch/Ledger/PrincipalTransport.lean`, now discharges exactly that, so the estimate was accurate rather than optimistic. It builds and is axiom-clean; its `degree_principal_eq_zero_of_isAlgClosed` differs from the ChiCurve route in *assuming* the two `Module.Finite` binders instead of synthesising them, but I confirmed both are satisfiable at `p1Over` over an algebraically closed field, so it is not vacuous. Its docstring correctly calls `[IsAlgClosed k]` load-bearing and scopes itself as "the k̄ case of `AJC.rr.principal`". For contrast, AJC's own open leaf `Scheme.WeilDivisor.principal_degree_zero` reports `sorryAx`.

### Checks I could not perform

- **Whether the blueprint should carry the new nodes.** Blueprint files are off-limits to this lane, and the two blueprint hits for `residueDeg_eq_one_of_isAlgClosed` / `degree_principal_eq_zero_of_isAlgClosed` are the pre-existing `Adelic.*_curve` declarations, not the new work. Whether that is a gap or correct deferral is a call for whoever owns the blueprint.
- **`horizon roadmap show` does not exist**, so I could not read `AJC.rr` milestone status directly to compare against the Lean state.
- **Task status vs. Lean.** `ajc-rr` is still `status: running` with uncommitted work in the tree, so "task status agrees with source" is not yet a meaningful question.
- I did not audit the ~9,800 ported lines for mathematical correctness; I verified provenance-by-diff against AJCR and sorry-freedom, and relied on AJCR's own sorry-free status for the bodies.

### Highest-value next action

Record the unrooted-cone limitation where a reader will hit it — a short paragraph in `GenusBridge.lean`'s "What this does and does not settle" section stating that the cone is not reachable from the root roll-up and therefore not covered by `scripts/axiom-frontier.lean`, plus an `issue` inbox item addressed to whoever owns the roll-up requesting the import. Everything else in this session's work stands as claimed; this is the one place where a clean axiom line could mislead a downstream consumer, and it is the project's own documented trap (5).
